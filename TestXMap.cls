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
	Test class for XMap
	@author Abhinav Gupta 
*/
global class TestXMap {
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
        XMap mpx = new XMap();
        mpx.put(new Employee('Abhinav', '232 256-1223', '432 456-3233', 17, true, 'Palam Vihar, Gurgaon, India'), 'Abhinav 1');
        // adding another employee with same key details i.e. name, mobile and postal. 
        mpx.put(new Employee('Abhinav', '232 256-1223', '123 333-4444', 30, true, 'Palam Vihar, Gurgaon, India'), 'Abhinav 2');
        
        // Map should be of Size 1 as per uniqueness criteria
        System.assertEquals(1, mpx.size());
        
        // adding another employee with different key details i.e. mobile no changed
        mpx.put(new Employee('Abhinav', '555 333-2222', '123 333-4444', 30, true, 'Palam Vihar, Gurgaon, India'), 'Abhinav 3');
        
        // Set should be of Size 2 as per uniqueness criteria
        System.assertEquals(2, mpx.size());
    }
    
    
    static testMethod void testAddAll() {
        XMap mpx = new XMap();
        mpx.put(new Employee('Abhinav', '232 256-1223', '432 456-3233', 17, true, 'Palam Vihar, Gurgaon, India'), 'Abhinav 1');
        // adding another employee with different key details i.e. mobile no changed
        mpx.put(new Employee('Abhinav', '555 333-2222', '123 333-4444', 30, true, 'Palam Vihar, Gurgaon, India'), 'Abhinav 2');
        
		XMap clonedMap = mpx.xclone();
		// should have 2 items
		System.assertEquals(2, clonedMap.size());
		// Add one more item to the clone
		clonedMap.put(new Employee('Johnny', '232 444-5555', '123 333-4444', 30, true, 'New York'), 'Abhinav 3');
		// should have 3 items, as last addition was unique
		System.assertEquals(3, clonedMap.size());
							        
		mpx.putAll(clonedMap);        
        // Set should be of Size 3 instead of 5 as per uniqueness criteria
        System.assertEquals(3, mpx.size());
    }
    
    
     static testMethod void testRemove() {
        Xmap setx = new Xmap();
        setx.put(new Employee('Abhinav', '232 256-1223', '432 456-3233', 17, true, 'Palam Vihar, Gurgaon, India'), 'A1');
        // adding another employee with different key details i.e. mobile no changed
        setx.put(new Employee('Abhinav', '555 333-2222', '123 333-4444', 30, true, 'Palam Vihar, Gurgaon, India'), 'A2');
        
		Employee johnny = new Employee('Johnny', '232 444-5555', '123 333-4444', 30, true, 'New York');
		setx.put(johnny, 'A3');
		// The key should be in map
		System.assert(setx.containsKey(johnny));
		
		// should have 3 items, as last addition was unique
		System.assertEquals(3, setx.size());
							        
		setx.remove(johnny);
		// After removal only 1 item should be left in xset i.e. Johnny.
        System.assertEquals(2, setx.size());
        
		setx.clear();
		//Now size should be zero again
		System.assert(setx.isEmpty());
		
    }

    static testMethod void testIterator() {
        Xmap setx = new Xmap();
        Employee emp1 = new Employee('Abhinav', '232 256-1223', '432 456-3233', 17, true, 'Palam Vihar, Gurgaon, India');
        setx.put(emp1, 'A1');
        // adding another employee with different key details i.e. mobile no changed
        Employee emp2 = new Employee('Abhinav', '555 333-2222', '123 333-4444', 30, true, 'Palam Vihar, Gurgaon, India');
        setx.put(emp2, 'A2');
        
        // load all the keys
        XSet keys = setx.keySet();
        // Check if they are proper
        System.assert(keys.contains(emp1));
        System.assert(keys.contains(emp2));
        
        // Load all the values
        List<Object> vals = setx.values();
        Set<String> valSet = new Set<String>();
        // Convert list to set for quick access
        for (Object o : vals) {
        	valSet.add(String.valueOf(o));
        }
        System.assert(valSet.contains('A1'));
        System.assert(valSet.contains('A2'));
        
    } 
}