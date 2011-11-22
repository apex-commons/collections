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
	Extends Apex map to support UDT(User Defined Types) to be used as Keys.
	@author Abhinav Gupta 
*/
global class XMap {
    // Key: Unique Key from XKeyables
    // Value : Any object passed by Client API
    private Map<String, Object> valueStore = new Map<String, Object>();
    private XSet keys = new XSet();
    
    global XMap(){
        
    }
    
    global XMap(XMap fromMap) {
        putAll(fromMap);
    }
    
    public void clear() {
        valueStore.clear();
    }
    
    public XMap xclone() {
        return new Xmap(this);
    }
    
    public Boolean containsKey(XKeyable k) {
        return valueStore.containsKey(k.getUniqueKey());
    }
    
    public Object get(XKeyable k) {
        return valueStore.get(k.getUniqueKey());
    }
    
    public Boolean isEmpty() {
        return valueStore.isEmpty();
    }
    
    /**
   Have to return XSet instead of apex Set, because of same UDTs limitation with Apex Set.
*/
    public XSet keySet() {
        return keys;
    }
    
    global Object put (XKeyable key, Object value) {
        String uniqkey = key.getUniqueKey();
        Object existing = valueStore.get(uniqkey);
        valueStore.put(uniqkey, value);
        keys.add(key);
        return existing;
    }
    
    global void putAll(XMap fromMap) {
        for (XKeyable k : fromMap.keyset().all()) {
            Object val = fromMap.get(k);
            put(k, val);
        }
    }
    
    global Object remove(XKeyable key) {
        String uniqkey = key.getUniqueKey();
        Object existing = valueStore.remove(uniqkey);
        keys.remove(key);
        return existing;
    }
    
    global Integer size() {
        return valueStore.size();
    }
    
    public Object[] values() {
        return valueStore.values();
    }
}