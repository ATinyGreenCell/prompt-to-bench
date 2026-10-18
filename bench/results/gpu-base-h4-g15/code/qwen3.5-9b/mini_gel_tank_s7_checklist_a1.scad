module tank_shell() {
           union() {
               // ... positive geometry ...
           }
           // Subtraction happens HERE, OUTSIDE the union
           translate(...) cylinder(...);
       }