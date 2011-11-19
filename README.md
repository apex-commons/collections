# What is XCollections ? #
Apex gives a decent Collections API with data structures like Set, List & Maps. 
They do a really good job most of the times, but have some limitations around 'User Defined Types(UDT)", like :

 * Set doesn't supports UDT, you can only use primitive types and Sobject with it.
 * Similarly, Map doesn't supports UDT as keys, it only supports primitive data types.

XCollections fills this gap by allowing one to use UDT's with both Set and Map.
Two new Apex classes named XSet & XMap are created for supporting UDT.

# How does it works ? #

The whole support mechanism for UDT depends on an apex interface i.e. **XKeyable**. This is a simple interface with even simpler contract.

## What is XKeyable and why implement its contract ? ##
Both Set items and Map keys depend on a unique KEY per Object for operating correctly. With primities the value itself becomes the KEY, as their is nothing else present to make use of. 
But with Custom or User Defined Types, one can't guess the uniquness criteria of the object, so we want some way to declare this.
 XKeyable sorts out this problem, by asking end client api about what is unique about this class/type. Hence, it requires the class to implement following 1 method only i.e.  

```java
/**
       Returns the Unique Key for this object, this Unique should be based on state.
       For ex. for Following User Defined type, mobile number + name can be unique composite key.
       This key will be acting as hash to decide the uniqueness in Set and locating correct keys in Map
       class Employee implements Keyable {
           String name;
           String mobile;
           
           public String getUniqueKey(){
               return name + mobile;
           }
       }
       
       @return A unique String composite or single key for this state of object.
    */
    String getUniqueKey ();

```

## Sample XKeyable implementation ##
Here is a classical Employee example, with some usual attributes and it implements the XKeyable interface too.

```java
global class Employee implements XKeyable {
         global String name;
         global String mobile;
         global String landLine;
         global Integer age; 
         global boolean isMale;
         global String postalAddress;
         
        global Employee (String n, String m, String l, 
                            Integer a, Boolean im, String pa) {
            name = n; 
            mobile = m;
            landLine = l;
            age = a;
            isMale = im;
            postalAddress = pa;
        }
        
        /** Uniqueness criteria is Name, Mobile and Postal Address here */
        global String getUniqueKey() {
            // assuming no two guys from same postal will carry same mobile and name :)
            return name + mobile + postalAddress;
        }
    }

```

## How to use XSet and XMap ##
Here is an example of using XSet with the same Employee class described above. 

```java

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

```

For more detailed examples about various other operations in Map/Set please check the Apex test classes. 

# What is planned next ?? #
Optimizing the collections for lesser space/time, plus introducing some more collections like :

 *  XSortedSet : Will keep the items sorted
 *  XLinkedSet : Will keep the items in insertion order like list.
 *  XLinkedMap : Will keep the keys in insertion order like list.
 *  Other collections .. 
 
 