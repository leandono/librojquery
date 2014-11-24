# Funciones y ejecuciones diferidas a través del objeto `$.Deferred`



## Introducción

A partir de la versión 1.5 de jQuery, la biblioteca introdujo una nueva utilidad: El objeto diferido `$.Deferred` (en inglés *Deferred Object*). Este objeto introduce nuevas formas para la invocación y ejecución de las funciones de devolución (*callbacks*), permitiendo crear aplicaciones más robustas y flexibles. Para más detalles sobre `$.Deferred`, puede consultar [http://api.jquery.com/category/deferred-object/](http://api.jquery.com/category/deferred-object/).


## El objeto diferido y Ajax

El caso más común en donde se puede apreciar la utilidad del objeto diferido es en el manejo de las funciones de devolución en peticiones Ajax.

Según se pudo apreciar en el capítulo dedicado, una manera de invocar una petición Ajax es:


**Manera tradicional de utilizar el método `$.ajax`**

```javascript
$.ajax({
   // la URL para la petición
   url : 'post.php',

   // funciónes de devolución a ejecutar
   // en caso que la petición haya sido
   // satisfactoria, con error y/o completada
   success : function(data) {
       alert('Petición realizada satisfactoriamente');
   },
   error : function(jqXHR, status, error) {
       alert('Disculpe, existió un problema');
   },
   complete : function(jqXHR, status) {
       alert('Petición realizada');
   }
});
```


Como se puede observar, las funciones de devolución son configuradas dentro del mismo objeto `$.ajax`. Esta manera es incomoda y poco flexible ya que **no permite desacoplar las funciones de devolución de la misma petición Ajax**. Y en grandes aplicaciones esto puede llegar a ser un problema. 

El objeto diferido nos permite reescribir el código anterior de la siguiente manera:


**El objeto diferido en una petición Ajax**

```javascript
// dentro de una variable se define 
// la configuración de la petición ajax
var ajax = $.ajax({
    url : 'post.php'
});

// a través del método done() ejecutamos
// la función de devolución satisfactoria (sucess)
ajax.done(function(){
	alert('Petición realizada satisfactoriamente');
});

// a través del método fail() ejecutamos
// la función de devolución de error (error)
ajax.fail(function(){
	alert('Disculpe, existió un problema');
});

// a través del método always() ejecutamos
// la función de devolución de petición completada (complete)
ajax.always(function(){
	alert('Petición realizada');
});
```


A través de los métodos `deferred.done`, `deferred.fail` y `deferred.always` es posible desacoplar las funciones de devolución de la misma petición Ajax, permitiendo un manejo más cómodo de las mismas.


*Notar que en en ningún momento se llama al objeto diferido `$.Deferred`. Esto es porque jQuery ya lo incorpora implícitamente dentro del manejo del objeto `$.ajax`. Más adelante se explicará como utilizar al objeto `$.Deferred` de manera explícita.*


De la misma forma es posible crear colas de funciones de devolución o atarlas a diferentes lógicas/acciones:


**Colas de funciones de devolución en una petición Ajax**

```javascript
// definición de la petición Ajax
var ajax = $.ajax({
    url : 'post.php'
});

// primera función de devolución a ejecutar
ajax.done(function(){
	alert('Primera función de devolución en caso satisfactorio');
});

// segunda función de devolución a ejecutar 
// inmediatamente después de la primera
ajax.done(function(){
	alert('Segunda función de devolución en caso satisfactorio');
});

// si el usuario hace click en #element se
// agrega una tercera función de devolución
$('#element').click(function(){

	ajax.done(function(){
		alert('Tercera función de devolución si el usuario hace click');
	});
	
});

// en caso que exista un error se define otra
// función de devolución
ajax.fail(function(){
	alert('Disculpe, existió un problema');
});
```


Al ejecutarse la petición Ajax, y en caso de que ésta haya sido satisfactoria, se ejecutan dos funciones de devolución, una detrás de la otra. Sin embargo si el usuario hace click en `#element` se agrega una tercera función de devolución, la cual también se ejecuta inmediatamente, sin volver a realizar la petición Ajax. Esto es porque el objeto diferido (que se encuentra implícitamente en la variable `ajax`) ya tiene información asociada sobre que la petición Ajax se realizó correctamente.



### `deferred.then`

Otra manera de utilizar los métodos `deferred.done` y `deferred.fail` es a través de `deferred.then`, el cual permite definir en un mismo bloque de código las funciones de devolución a suceder en los casos satisfactorios y erróneos.


**Utilización del método `deferred.then`**

```javascript
// definición de la petición Ajax
var ajax = $.ajax({
    url : 'post.php'
});

// el método espera dos funciones de devolución
ajax.then(

	// la primera es la función de devolución satisfactoria
   	function(){ 
   		alert('Petición realizada satisfactoriamente'); 
   	},
   	
   	// la segunda es la función de devolución errónea
   	function(){ 
   		alert('Disculpe, existió un problema');
   	}
   	
);
```


## Creación de objetos diferidos con `$.Deferred`

Así como es posible desacoplar las funciones de devolución en una petición Ajax, también es posible realizarlo en otras funciones utilizando de manera explícita el objeto `$.Deferred`.

Por ejemplo, una función que verifica si un número es par, de la manera tradicional puede escribirse de la siguiente manera:


**Función sin utilizar el objeto `$.Deferred`**

```javascript
// función que calcula si un número entero es par o impar
var isEven = function(number) {

	if (number%2 == 0){
		return true;
	} else {
		return false;
	}
	
}

// si es par registra un mensaje,
// en caso contrario registra otro
if (isEven(2)){
	console.log('Es par');
} else {
	console.log('Es impar');
}
```


Utilizando el objeto `$.Deferred`, el mismo ejemplo puede reescribirse de la siguiente forma:


**Función utilizando el objeto `$.Deferred`**

```javascript
// función que calcula si un número entero es par o impar
var isEven = function(number) {
	
	// guarda en una variable al objeto $.Deferred()
	var dfd = $.Deferred();
	
	// si es par, resuelve al objeto utilizando deferred.resolve,
	// caso contrario, lo rechaza utilizando deferred.reject
	if (number%2 == 0){
		dfd.resolve();
	} else {
		dfd.reject();
	}
	
	// devuelve al objeto diferido con su estado definido
	return dfd.promise();
	
}

// con deferred.then se manejan las funciones de devolución
// en los casos que el numero sea par o impar
isEven(2).then(

	// la primera es la función de devolución satisfactoria
   	function(){ 
   		console.log('Es par');
   	},
   	
   	// la segunda es la función de devolución errónea
   	function(){ 
   		console.log('Es impar');
   	}
   	
);
```


Los métodos `deferred.resolve` y `deferred.reject` permiten **definir el estado interno** del objeto `$.Deferred()`. Esta definición **es permanente, es decir, no es posible modificarla después** y es lo que permite manejar el comportamiento y ejecución de las funciones de devolución posteriores para cada uno de los casos.

Notar que la función `isEven` devuelve el método `deferred.promise`. El mismo es una versión del objeto diferido, pero que sólo permite leer su estado o añadir nuevas funciones de devolución.


> **Nota**
>
> En los ejemplos que utilizaban Ajax mostrados anteriormente, los métodos `deferred.resolve` y `deferred.reject` son llamados de manera interna por jQuery dentro de la configuración `sucess` y `error` de la petición. Por eso mismos se decía que el objeto diferido estaba incorporado implícitamente dentro del objeto `$.ajax`.



Los métodos `deferred.resolve` y `deferred.reject` además permiten devolver valores para ser utilizados por las funciones de devolución.


**Función con `deferred.resolve` y `deferred.reject` devolviendo valores reutilizables**

```javascript
// función que calcula si un numero entero es par o impar
var isEven = function(number) {
	
	var dfd = $.Deferred();
	
	// resuelve o rechaza al objeto utilizando
	// y devuelve un texto con el resultado
	if (number%2 == 0){
		dfd.resolve('El número ' + number + ' es par');
	} else {
		dfd.reject('El número ' + number + ' es impar');
	}
	
	// devuelve al objeto diferido con su estado definido
	return dfd.promise();
	
}

isEven(2).then(

   	function(result){ 
   		console.log(result); // Registra 'El número 2 es par'
   	},
   	
   	function(result){ 
   		console.log(result);
   	}
   	
);
```


> **Nota**
>
> Es posible determinar el estado de un objeto diferido a través del método `deferred.state`. El mismo devuelve un string con alguno de estos tres valores: `pending`, `resolved` o `rejected`. Para más detalles sobre `deferred.state`, puede consultar [http://api.jquery.com/deferred.state/](http://api.jquery.com/deferred.state/).



### `deferred.pipe`

Existen casos en que se necesita modificar el estado de un objeto diferido o filtrar la información que viene asociada. Para estos casos existe `deferred.pipe`. Su funcionamiento es similar a `deferred.then`, con la diferencia que `deferred.pipe` devuelve un nuevo objeto diferido modificado a través de una función interna.


**Función filtrando valores utilizando `deferred.pipe`**

```javascript
// función que calcula si un número entero es par o impar
var isEven = function(number) {
    
    var dfd = $.Deferred();

    if (number%2 == 0){
        dfd.resolve(number);
    } else {
        dfd.reject(number);
    }
    
    return dfd.promise();
    
}

// vector con una serie de números pares e impares
var numbers = [0, 2, 9, 10, 5, 8, 12];

// a través de deferred.pipe se pregunta si número se encuentra
// dentro del vector numbers
isEven(2).pipe(
    
    function(number){
        
        // crea un nuevo objeto diferido
        var dfd = $.Deferred();
        
        if($.inArray(number, numbers) !== -1){ 
            dfd.resolve();
        } else {
            dfd.reject();
        }
        
        // devuelve un nuevo objeto diferido
        return dfd.promise();
        
    }
    
).then(

    function(){
    	// al estar dentro del vector numbers y ser par,
    	// se registra este mensaje
        console.log('El número es par y se encuentra dentro de numbers');
    },
    
    function(){
        console.log('El número es impar o no se encuentra dentro de numbers');
    }
    
);
```


Para más detalles sobre `deferred.pipe`, puede consultar [http://api.jquery.com/deferred.pipe/](http://api.jquery.com/deferred.pipe/).


### `$.when`

El método `$.when` permite ejecutar funciones de devolución, cuando uno o más objetos diferidos posean algún estado definido.

Un caso común de utilización de `$.when` es cuando se quiere verificar que dos peticiones Ajax separadas se han realizado.

**Utilización de `$.when`**

```javascript
// primera petición ajax
var comments = $.ajax({
    url : '/echo/json/'
});

// segunda petición ajax
var validation = $.ajax({
    url : '/echo/json/'
});

// cuando las dos peticiones sean realizadas
// ejecuta alguna función de devolución definida
// dentro de deferred.then
$.when(comments, validation).then(
    function(){
        alert('Peticiones realizadas');
    },
    function(){
        alert('Disculpe, existió un problema');
    }
);
```


Para más detalles sobre `$.when`, puede consultar [http://api.jquery.com/jQuery.when/](http://api.jquery.com/jQuery.when/).
