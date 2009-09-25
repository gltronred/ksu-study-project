package org.kohomologie.gasaccount.dao;

/**
 *
 * @author antechrome
 */

public aspect Logging{

    after(): execution(* sayHello(..)){
        System.out.println("again ololo lol\n");
    }

}
