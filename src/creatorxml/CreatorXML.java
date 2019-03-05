/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package creatorxml;

import java.io.File;
/**
 *
 * @author pablojy
 */
public class CreatorXML {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        System.out.println("hola mundo");
        generarCup();
        ventIni v1 = new ventIni();
        v1.show(true);
    }
    
    public static void generarCup(){
        String path ="/home/pablojy/NetBeansProjects/CreatorXML/src/analizadores/scanner.flex";
        generarLexema(path);
        String cadena[] = new String [5];
        cadena[0]="-destdir";
        cadena[1]="/home/pablojy/NetBeansProjects/CreatorXML/src/analizadores";
        cadena[2]="-parser";
        cadena[3]="parser";
        cadena[4]="/home/pablojy/NetBeansProjects/CreatorXML/src/analizadores/parser.cup";
        try{
            java_cup.Main.main(cadena);
        }catch(Exception e){
            System.out.println(e);
        }
    }
    
    public static void generarLexema(String path){
        File file= new File(path);
        jflex.Main.generate(file);
    }
}
