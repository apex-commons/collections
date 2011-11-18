/*
Copyright (c) 2011 tgerm.com
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. The name of the author may not be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
/**
	Extends Apex Set class functionality to support UDT(User defined types).
	@author Abhinav Gupta 
*/
global class XSet implements Iterable<XKeyable>{
    
    global class XSetIterator implements Iterator<XKeyable> {
        private List<XKeyable> keys;
        private Integer index = 0;
        
        global XSetIterator(List<XKeyable> items) {
           this.keys = items;   
        }
        
       global boolean hasNext(){ 
           return index < keys.size(); 
        }
          
       global XKeyable next(){ 
           return keys[index++]; 
       }    
    }

    // internal collection for handling UDTs
    private Map<String, XKeyable> store = new Map<String, XKeyable>();
    
    global XSet(){
    }
    
    global XSet(List<XKeyable> keys) {
        addAll(keys);
    }
    
    global Boolean add(XKeyable key) {
        String uniqkey = key.getUniqueKey();
        XKeyable existing = store.get(uniqkey);
        if (existing == null) {
            store.put(uniqkey, key);    
        }
        return existing == null;
    }
    
    global Boolean addAll(List<XKeyable> keys) {
        Integer sizeBefore = size();
        // Add all keys
        for (XKeyable key : keys) add(key);
        
        Integer sizeAfter = size();
        // If any change has occured these sizes will vary
        return sizeAfter != sizeBefore ;
    }
    
    global Boolean addAll(XSet setx) {
        return addAll(setx.all());
    }
    
    
    global void clear() {
        store.clear();
    }
    
    /**
        Note: clone() method in set is named as xclone because of following limitation
        imposed by apex 
        "Non-virtual, non-abstract methods cannot be overriden: XCollections.XSet clone() "
        
    */
    global XSet xclone() {
        return new XSet(all());
    }
    
    global boolean contains(XKeyable k) {
        return store.containsKey(k.getUniqueKey());
    }
    
    global boolean containsAll(List<XKeyable> vals){
        for (XKeyable k : vals) {
            if (!contains(k)) return false;
        }
        return true;
    }
    
    global boolean containsAll(XSet setx){
        return containsAll(setx.all());
    }
    
    global Boolean isEmpty() {
        return store.isEmpty();
    }
    
    global Boolean remove(XKeyable k) {
        XKeyable existing =  store.remove(k.getUniqueKey());
        // if something exists that means set changed
        return existing != null;
    }
    
    global Boolean removeAll(List<XKeyable> keys) {
        Integer sizeBefore = size();
        // remove all keys
        for (XKeyable key : keys) remove(key);
        
        Integer sizeAfter = size();
        // If any change has occured these sizes will vary
        return sizeAfter != sizeBefore ;
    }
    
    global Boolean removeAll(XSet setx) {
        return removeAll(setx.all());
    }
    
    global Boolean retainAll(List<XKeyable> keys) {
        Integer sizeBefore = size();
        XSet otherSet = new XSet(keys);
        // remove all keys
        for (XKeyable key : store.values()) {
            if (!otherSet.contains(key))
               remove(key);
        }
        
        Integer sizeAfter = size();
        // If any change has occured these sizes will vary
        return sizeAfter != sizeBefore ;
    }
    
    global Boolean retainAll(XSet otherSet) {
        return retainAll(otherSet.all());
    }
    
    
    global Integer size() {
        return store.size();
    }
    
    /**
        Add as a custom apex class can't fit into for .. each iterator supported by apex
        so if you want to iterate over the set, either use this Array or call iterator() method to return
        a Iterator instance and then use it for iteration.
    */
    global XKeyable[] all(){
        return store.values();
    }
    
    /**
        Add as a custom apex class can't fit into for .. each iterator supported by apex
        so if you want to iterate over the set, either use this iterator or call all() method to return all keys 
        back in form of Array.
        Iterator is native Apex class, it has two key methods for helping in 
        iterator i.e. hasNext() and next(), 
        more details in Iterator docs : http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_classes_iterable.htm
    */
    global Iterator<XKeyable> iterator() {
        return new XSetIterator(store.values());
    }
    
}