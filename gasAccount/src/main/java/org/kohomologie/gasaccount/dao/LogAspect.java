/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.kohomologie.gasaccount.dao;
import org.aspectj.lang.annotation.Aspect;

import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Pointcut;

/**
 *
 * @author antechrome
 */
@Aspect
public class LogAspect {
 @Pointcut("execution(* sayHello(..))")
 void helloMethods(){};

 @After ("helloMethods()")
 public void sayDeath()
 {
     System.out.println("death and torture");
 }
}
