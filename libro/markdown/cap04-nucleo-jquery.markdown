# El núcleo de jQuery



## `$` vs `$()`

Hasta ahora, se ha tratado completamente con métodos que se llaman desde el objeto jQuery. Por ejemplo:

```javascript
$('h1').remove();
```

Dichos métodos son parte del espacio de nombres (en inglés *namespace*) `$.fn`, o del prototipo (en inglés *prototype*) de jQuery, y son considerados como métodos del objeto jQuery.

Sin embargo, existen métodos que son parte del espacio de nombres de $ y se consideran como métodos del núcleo de jQuery.

Estas distinciones pueden ser bastantes confusas para usuarios nuevos. Para evitar la confusión, debe recordar estos dos puntos:

-   los métodos utilizados en selecciones se encuentran dentro del espacio de nombres `$.fn`, y automáticamente reciben y devuelven una selección en sí;

-   métodos en el espacio de nombres `$` son generalmente métodos para diferentes utilidades, no trabajan con selecciones, no se les pasa ningún argumento y el valor que devuelven puede variar.

Existen algunos casos en donde métodos del objeto y del núcleo poseen los mismos nombres, como sucede con `$.each` y `$.fn.each`. En estos casos, debe ser cuidadoso de leer bien la documentación para saber que objeto utilizar correctamente.



## Métodos Utilitarios

jQuery ofrece varios métodos utilitarios dentro del espacio de nombres `$`. Estos métodos son de gran ayuda para llevar a cabo tareas rutinarias de programación. A continuación se muestran algunos ejemplos, para una completa documentación sobre ellos, visite [http://api.jquery.com/category/utilities/](http://api.jquery.com/category/utilities/).

 $.trim
  ~ Remueve los espacios en blanco del principio y final.

```javascript
$.trim('    varios espacios en blanco   ');
// devuelve 'varios espacios en blanco'
```

 $.each
  ~ Interactúa en vectores y objetos.

```javascript
$.each([ 'foo', 'bar', 'baz' ], function(idx, val) {
    console.log('elemento ' + idx + 'es ' + val);
});

$.each({ foo : 'bar', baz : 'bim' }, function(k, v) {
    console.log(k + ' : ' + v);
});
```


>   **Nota**
>
>    Como se dijo antes, existe un método llamado `$.fn.each`, el cual interactúa en una selección de elementos.


 $.inArray
  ~ Devuelve el índice de un valor en un vector, o -1 si el valor no se encuentra en el vector.

```javascript
var myArray = [ 1, 2, 3, 5 ];

if ($.inArray(4, myArray) !== -1) {
    console.log('valor encontrado');
}
```

 $.extend
  ~ Cambia la propiedades del primer objeto utilizando las propiedades de los subsecuentes objetos.

```javascript
var firstObject = { foo : 'bar', a : 'b' };
var secondObject = { foo : 'baz' };

var newObject = $.extend(firstObject, secondObject);
console.log(firstObject.foo); // 'baz'
console.log(newObject.foo);   // 'baz'
```

Si no se desea cambiar las propiedades de ninguno de los objetos que se utilizan en `$.extend`, se debe incluir un objeto vacío como primer argumento.

```javascript
var firstObject = { foo : 'bar', a : 'b' };
var secondObject = { foo : 'baz' };

var newObject = $.extend({}, firstObject, secondObject);
console.log(firstObject.foo); // 'bar'
console.log(newObject.foo);   // 'baz'
```

 $.proxy
  ~ Devuelve una función que siempre se ejecutará en el alcance (*scope*) provisto — en otras palabras, establece el significado de *this* (incluido dentro de la función) como el segundo argumento.

```javascript
var myFunction = function() { console.log(this); };
var myObject = { foo : 'bar' };

myFunction(); // devuelve el objeto window

var myProxyFunction = $.proxy(myFunction, myObject);
myProxyFunction(); // devuelve el objeto myObject
```

Si se posee un objeto con métodos, es posible pasar dicho objeto y el nombre de un método para devolver una función que siempre se ejecuta en el alcance de dicho objeto.

```javascript
var myObject = {
    myFn : function() {
        console.log(this);
    }
};

$('#foo').click(myObject.myFn); // registra el elemento DOM #foo
$('#foo').click($.proxy(myObject, 'myFn')); // registra myObject
```



## Comprobación de Tipos

Como se mencionó en el capítulo "Conceptos Básicos de JavaScript", jQuery ofrece varios métodos útiles para determinar el tipo de un valor específico.


**Comprobar el tipo de un determinado valor**

```javascript
var myValue = [1, 2, 3];

// Utilizar el operador typeof de JavaScript para comprobar tipos primitivos
typeof myValue == 'string'; // falso (false)
typeof myValue == 'number'; // falso (false)
typeof myValue == 'undefined'; // falso (false)
typeof myValue == 'boolean'; // falso (false)

// Utilizar el operador de igualdad estricta para comprobar valores nulos (null)
myValue === null; // falso (false)

// Utilizar los métodos jQuery para comprobar tipos no primitivos
jQuery.isFunction(myValue); // falso (false)
jQuery.isPlainObject(myValue); // falso (false)
jQuery.isArray(myValue); // verdadero (true)
jQuery.isNumeric(16); // verdadero (true). No disponible en versiones inferiores a jQuery 1.7
```



## El Método Data

A menudo encontrará que existe información acerca de un elemento que necesita guardar. En JavaScript es posible hacerlo añadiendo propiedades al DOM del elemento, pero esta práctica conlleva enfrentarse a pérdidas de memoria (en inglés *memory leaks*) en algunos navegadores. jQuery ofrece una manera sencilla para poder guardar información relacionada a un elemento, y la misma biblioteca se ocupa de manejar los problemas que pueden surgir por falta de memoria.


**Guardar y recuperar información relacionada a un elemento**

```javascript
$('#myDiv').data('keyName', { foo : 'bar' });
$('#myDiv').data('keyName'); // { foo : 'bar' }
```

A través del método `$.fn.data` es posible guardar cualquier tipo de información sobre un elemento. Es difícil exagerar la importancia de este concepto cuando se está desarrollando una aplicación compleja.

Por ejemplo, si desea establecer una relación entre el ítem de una lista y el div que hay dentro de este ítem, es posible hacerlo cada vez que se interactúa con el ítem, pero una mejor solución es hacerlo una sola vez, guardando un puntero al div utilizando el método `$.fn.data`:

**Establecer una relación entre elementos utilizando el método `$.fn.data`**

```javascript
$('#myList li').each(function() {
    var $li = $(this), $div = $li.find('div.content');
    $li.data('contentDiv', $div);
});

// luego, no se debe volver a buscar al div;
// es posible leerlo desde la información asociada al item de la lista
var $firstLi = $('#myList li:first');
$firstLi.data('contentDiv').html('nuevo contenido');
```

Además es posible pasarle al método un objeto conteniendo uno o más pares de conjuntos palabra clave-valor.

A partir de la versión 1.5 de la biblioteca, jQuery permite utilizar al método `$.fn.data` para obtener la información asociada a un elemento que posea el atributo HTML5 `data-*`:

**Elementos con el atributo `data-*`**

```html
<a id='foo' data-foo='baz' href='#'>Foo</a>

<a id='foobar' data-foo-bar='fol' href='#'>Foo Bar</a>
```

**Obtener los valores asociados a los atributos `data-*` con `$.fn.data`**

```javascript
// obtiene el valor del atributo data-foo
// utilizando el método $.fn.data
console.log($('#foo').data('foo')); // registra 'baz'

// obtiene el valor del segundo elemento
console.log($('#foobar').data('fooBar')); // registra 'fol'
```


> **Nota**
>
> A partir de la versión 1.6 de la biblioteca, para obtener el valor del atributo `data-foo-bar` del segundo elemento, el argumento en `$.fn.data` se debe pasar en estilo *CamelCase*.


> **Nota**
>
> Para más información sobre el atributo HTML5 `data-*` visite [http://www.w3.org/TR/html5/global-attributes.html#embedding-custom-non-visible-data-with-the-data-attributes](http://www.w3.org/TR/html5/global-attributes.html#embedding-custom-non-visible-data-with-the-data-attributes).



## Detección de Navegadores y Características

Más allá que jQuery elimine la mayoría de las peculiaridades de JavaScript entre cada navegador, existen ocasiones en que se necesita ejecutar código en un navegador específico.

Para este tipo de situaciones, jQuery ofrece el objeto `$.support` y `$.browser` (este último en desuso). Una completa documentación sobre estos objetos puede encontrarla en [http://api.jquery.com/jQuery.support/](http://api.jquery.com/jQuery.support/) y [http://api.jquery.com/jQuery.browser/](http://api.jquery.com/jQuery.browser/)

El objetivo de `$.support` es determinar qué características soporta el navegador web.

El objeto `$.browser` permite detectar el tipo de navegador y su versión. Dicho objeto está en desuso (aunque en el corto plazo no está planificada su eliminación del núcleo de la biblioteca) y se recomienda utilizar al objeto `$.support` para estos propósitos.



## Evitar Conflictos con Otras Bibliotecas JavaScript

Si esta utilizando jQuery en conjunto con otras bibliotecas JavaScript, las cuales también utilizan la variable `$`, pueden llegar a ocurrir una serie de errores. Para poder solucionarlos, es necesario poner a jQuery en su modo "no-conflicto". Esto se debe realizar inmediatamente después que jQuery se cargue en la página y antes del código que se va a ejecutar.

Cuando se pone a jQuery en modo "no-conflicto", la biblioteca ofrece la opción de asignar un nombre para reemplazar a la variable `$`.


**Poner a jQuery en modo no-conflicto**

```javascript
<script src="prototype.js"></script>             // la biblioteca prototype
                                                 // también utiliza $
<script src="jquery.js"></script>                // se carga jquery
                                                 // en la página
<script>var $j = jQuery.noConflict();</script>   // se inicializa
                                                 // el modo "no-conflicto"
```

También es posible seguir utilizando `$` conteniendo el código en una función anónima autoejecutable. Éste es un patrón estándar para la creación de extensiones para la biblioteca, ya que `$` queda encerrada dentro del alcance de la misma función anónima.


**Utilizar $ dentro de una función anónima autoejecutable**

```javascript
<script src="prototype.js"></script>
<script src="jquery.js"></script>
<script>
jQuery.noConflict();

(function($) {
   // el código va aquí, pudiendo utilizar $
})(jQuery);
</script>
```



