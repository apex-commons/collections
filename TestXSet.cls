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
	Test class for XSET, have to keep it global because of Apex limitations.
	@author Abhinav Gupta 
*/
global class TestXSet {

     global class Employee implements XKeyable {
         String name;
         String mobile;
         String landLine;
         Integer age;
         boolean isMale;
         String postalAddress;
         
        global Employee (String n, String m, String l, 
                            Integer a, Boolean im, String pa) {
            name = n; 
            mobile = m;
            landLine = l;
            age = a;
            isMale = im;
            postalAddress = pa;
        }
        
        global String getUniqueKey() {
            // assuming no two guys from same postal will carry same mobile and name :)
            return name + mobile + postalAddress;
        }
    }
    
    static testMethod void testBasicSetBehavior() {
        XSet setx = new XSet();
        setx.add(new Employee('Abhinav', '232 256-1223', '432 456-3233', 17, true, 'Palam Vihar, Gurgaon, India'));
        // adding another employee with same key details i.e. name, mobile and postal. 
        setx.add(new Employee('Abhinav', '232 256-1223', '123 333-4444', 30, true, 'Palam Vihar, Gurgaon, India'));
        
        // Set should be of Size 1 as per uniqueness criteria
        System.assertEquals(1, setx.size());
        
        // adding another employee with different key details i.e. mobile no changed
        setx.add(new Employee('Abhinav', '555 333-2222', '123 333-4444', 30, true, 'Palam Vihar, Gurgaon, India'));
        
        // Set should be of Size 2 as per uniqueness criteria
        System.assertEquals(2, setx.size());
    }
    
     static testMethod void testAddAll() {
        XSet setx = new XSet();
        setx.add(new Employee('Abhinav', '232 256-1223', '432 456-3233', 17, true, 'Palam Vihar, Gurgaon, India'));
        // adding another employee with different key details i.e. mobile no changed
        setx.add(new Employee('Abhinav', '555 333-2222', '123 333-4444', 30, true, 'Palam Vihar, Gurgaon, India'));
        
		XSet clonedSet = setx.xclone();
		// should have 2 items
		System.assertEquals(2, clonedSet.size());
		// Add one more item to the clone
		clonedSet.add(new Employee('Johnny', '232 444-5555', '123 333-4444', 30, true, 'New York'));
		// should have 3 items, as last addition was unique
		System.assertEquals(3, clonedSet.size());
							        
		setx.addAll(clonedSet);        
        // Set should be of Size 3 instead of 5 as per uniqueness criteria
        System.assertEquals(3, setx.size());
    }

     static testMethod void testRemove() {
        XSet setx = new XSet();
        setx.add(new Employee('Abhinav', '232 256-1223', '432 456-3233', 17, true, 'Palam Vihar, Gurgaon, India'));
        // adding another employee with different key details i.e. mobile no changed
        setx.add(new Employee('Abhinav', '555 333-2222', '123 333-4444', 30, true, 'Palam Vihar, Gurgaon, India'));
        
		XSet clonedSet = setx.xclone();
		// should have 2 items
		System.assertEquals(2, clonedSet.size());
		// Add one more item to the clone
		Employee johnny = new Employee('Johnny', '232 444-5555', '123 333-4444', 30, true, 'New York');
		clonedSet.add(johnny);
		// should have 3 items, as last addition was unique
		System.assertEquals(3, clonedSet.size());
							        
		clonedSet.removeAll(setx);
		// After removal only 1 item should be left in xset i.e. Johnny.
        System.assertEquals(1, clonedSet.size());
        
		Employee inSet = (Employee)clonedSet.iterator().next();
		System.assertEquals(inSet, johnny);
		// johnny is still in set
		System.assert(clonedSet.remove(johnny));
		// nothing left in cloned set now 
		System.assert(clonedSet.isEmpty());
		
		// add johnny one more time 
		clonedSet.add(johnny);
		clonedSet.clear();
		//Now size should be zero again
		System.assert(clonedSet.isEmpty());
		
    }


	static testMethod void testRetain() {
        XSet setx = new XSet();
        setx.add(new Employee('Abhinav', '232 256-1223', '432 456-3233', 17, true, 'Palam Vihar, Gurgaon, India'));
        // adding another employee with different key details i.e. mobile no changed
        setx.add(new Employee('Abhinav', '555 333-2222', '123 333-4444', 30, true, 'Palam Vihar, Gurgaon, India'));
        
		XSet clonedSet = setx.xclone();
		// should have 2 items
		System.assertEquals(2, clonedSet.size());
		// Add one more item to the clone
		Employee johnny = new Employee('Johnny', '232 444-5555', '123 333-4444', 30, true, 'New York');
		clonedSet.add(johnny);
		// should have 3 items, as last addition was unique
		System.assertEquals(3, clonedSet.size());
							        
		clonedSet.retainAll(setx);
		// After retain only 2 items should be left in xset i.e. except Johnny.
        System.assertEquals(2, clonedSet.size());
        
        //now both sets should contain everything in other.
        System.assert(clonedSet.containsAll(setx)); 
        
        // johnny shouldn't be part of set now.
        System.assert(!clonedSet.contains(johnny));
    }
    
    static testMethod void testIterator() {
        XSet setx = new XSet();
        setx.add(new Employee('Abhinav', '232 256-1223', '432 456-3233', 17, true, 'Palam Vihar, Gurgaon, India'));
        // adding another employee with different key details i.e. mobile no changed
        setx.add(new Employee('Abhinav', '555 333-2222', '123 333-4444', 30, true, 'Palam Vihar, Gurgaon, India'));
        
        Iterator<XKeyable> itr = setx.iterator();
        System.assert(itr.hasNext());
        // move to first item
		itr.next();
		// true for second items        
    	System.assert(itr.hasNext());
        // move to second item
		itr.next();
		
		// false as no item should be next        
    	System.assert(!itr.hasNext());
    } 

}