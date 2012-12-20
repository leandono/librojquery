# Mejores Prácticas para Aumentar el Rendimiento

Este capítulo cubre numerosas mejores prácticas de JavaScript y jQuery,sin un orden en particular. Muchas de estas prácticas están basadas en la presentación [jQuery Anti-Patterns for Performance](http://paulirish.com/perf) (en inglés) de Paul Irish.



## Guardar la Longitud en Bucles

En un bucle, no es necesario acceder a la longitud de un vector cada vez que se evalúa la condición; dicho valor se puede guardar previamente en una variable.

```javascript
var myLength = myArray.length;

for (var i = 0; i < myLength; i++) {
    // do stuff
}
```



## Añadir Nuevo Contenido por Fuera de un Bucle

Si va a insertar muchos elementos en el DOM, hágalo todo de una sola vez, no de una por vez.

```javascript
// mal
$.each(myArray, function(i, item) {
   var newListItem = '<li>' + item + '</li>';
   $('#ballers').append(newListItem);
});

// mejor: realizar esto
var frag = document.createDocumentFragment();

$.each(myArray, function(i, item) {
    var newListItem = '<li>' + item + '</li>';
    frag.appendChild(newListItem);
});
$('#ballers')[0].appendChild(frag);

// o esto:
var myHtml = '';

$.each(myArray, function(i, item) {
    myHtml += '<li>' + item + '</li>';
});
$('#ballers').html(myHtml);
```



## No Repetirse

No se repita; realice las cosas una vez y sólo una, caso contrario lo estará haciendo mal.

```javascript
// MAL
if ($eventfade.data('currently') != 'showing') {
    $eventfade.stop();
}

if ($eventhover.data('currently') != 'showing') {
    $eventhover.stop();
}

if ($spans.data('currently') != 'showing') {
    $spans.stop();
}

// BIEN
var $elems = [$eventfade, $eventhover, $spans];
$.each($elems, function(i,elem) {
    if (elem.data('currently') != 'showing') {
        elem.stop();
    }
});
```



## Cuidado con las Funciones Anónimas

No es aconsejable utilizar de sobremanera las funciones anónimas. Estas son difíciles de depurar, mantener, probar o reutilizar. En su lugar,utilice un objeto literal para organizar y nombrar sus controladores y funciones de devolución de llamada.

```javascript
// MAL
$(document).ready(function() {
    $('#magic').click(function(e) {
        $('#yayeffects').slideUp(function() {
            // ...
        });
    });

    $('#happiness').load(url + ' #unicorns', function() {
        // ...
    });
});

// MEJOR
var PI = {
    onReady : function() {
        $('#magic').click(PI.candyMtn);
        $('#happiness').load(PI.url + ' #unicorns', PI.unicornCb);
    },

    candyMtn : function(e) {
        $('#yayeffects').slideUp(PI.slideCb);
    },

    slideCb : function() { ... },

    unicornCb : function() { ... }
};

$(document).ready(PI.onReady);
```



## Optimización de Selectores

La optimización de selectores es menos importante de lo que solía ser, debido a la implementación en algunos navegadores de`document.querySelectorAll()`, pasando la carga de jQuery hacia el navegador. Sin embargo, existen algunos consejos que debe tener en cuenta.



### Selectores basados en ID

Siempre es mejor comenzar las selecciones con un ID.

```javascript
// rápido
$('#container div.robotarm');

// super-rápido
$('#container').find('div.robotarm');
```

El ejemplo que utiliza `$.fn.find` es más rápido debido a que la primera selección utiliza el motor de selección interno [Sizzle](http://sizzlejs.com/) — mientras que la selección realizada únicamente por ID utiliza `document.getElementById()`, el cual es extremadamente rápido debido a que es una función nativa del navegador.



### Especificidad

Trate de ser especifico para el lado derecho de la selección y menos específico para el izquierdo.

```javascript
// no optimizado
$('div.data .gonzalez');

// optimizado
$('.data td.gonzalez');
```

Use en lo posible `etiqueta.clase` del lado derecho de la selección, y solo `etiqueta` o `.clase` en la parte izquierda.

```javascript
$('.data table.attendees td.gonzalez');

// mucho mejor: eliminar la parte media de ser posible
$('.data td.gonzalez');
```

La segunda selección tiene mejor rendimiento debido a que atraviesa menos capas para buscar el elemento.



### Evitar el Selector Universal

Selecciones en donde se especifica de forma implícita o explícita una selección universal puede resultar muy lento.

```javascript
$('.buttons > *');      // muy lento
$('.buttons').children();  // mucho mejor

$('.gender :radio');       // selección universal implícita
$('.gender *:radio');      // misma forma, pero de forma explícita
$('.gender input:radio');  // mucho mejor
```



## Utilizar la Delegación de Eventos

La delegación de eventos permite vincular un controlador de evento a un elemento contenedor (por ejemplo, una lista desordenada) en lugar de múltiples elementos contenidos (por ejemplo, los ítems de una lista). jQuery hace fácil este trabajo a través de `$.fn.live` y`$.fn.delegate`. En lo posible, es recomendable utilizar `$.fn.delegate` en lugar de `$.fn.live`, ya que elimina la necesidad de una selección y su contexto explícito reduce la carga en aproximadamente un 80%.

Además, la delegación de eventos permite añadir nuevos elementos contenedores a la página sin tener que volver a vincular sus controladores de eventos.

```javascript
// mal (si existen muchos items en la lista)
$('li.trigger').click(handlerFn);

// mejor: delegación de eventos con $.fn.live
$('li.trigger').live('click', handlerFn);

// mucho mejor: delegación de eventos con $.fn.delegate
// permite especificar un contexto de forma fácil
$('#myList').delegate('li.trigger', 'click', handlerFn);
```



## Separar Elementos para Trabajar con Ellos

En lo posible, hay que evitar la manipulación del DOM. Para ayudar con este propósito, a partir de la versión 1.4, jQuery introduce `$.fn.detach` el cual permite trabajar elementos de forma separada del DOM para luego insertarlos.

```javascript
var $table = $('#myTable');
var $parent = $table.parent();

$table.detach();
// ... se añaden muchas celdas a la tabla
$parent.append(table);
```



## Utilizar Estilos en Cascada para Cambios de CSS en Varios Elementos

Si va a cambiar el CSS en más de 20 elementos utilizando `$.fn.css`, considere realizar los cambios de estilos añadiéndolos en una etiqueta *style*. De esta forma se incrementa un 60% el rendimiento.

```javascript
// correcto hasta 20 elementos, lento en más elementos
$('a.swedberg').css('color', '#asd123');
$('<style type="text/css">a.swedberg { color : #asd123 }</style>')
    .appendTo('head');
```



## Utilizar `$.data` en Lugar de `$.fn.data`

Utilizar `$.data` en un elemento del DOM en lugar de `$.fn.data` en una selección puede ser hasta 10 veces más rápido. Antes de realizarlo, este seguro de comprender la diferencia entre un elemento DOM y una selección jQuery.

```javascript
// regular
$(elem).data(key,value);

// 10 veces más rápido
$.data(elem,key,value);
```



## No Actuar en Elementos no Existentes

jQuery no le dirá si esta tratando de ejecutar código en una selección vacía — esta se ejecutará como si nada estuviera mal. Dependerá de usted comprobar si la selección contiene elementos.

```javascript
// MAL: el código a continuación ejecuta tres funciones
// sin comprobar si existen elementos
// en la selección
$('#nosuchthing').slideUp();

// Mejor
var $mySelection = $('#nosuchthing');
if ($mySelection.length) { $mySelection.slideUp(); }

// MUCHO MEJOR: añadir una extensión doOnce
jQuery.fn.doOnce = function(func){
    this.length && func.apply(this);
    return this;

}


$('li.cartitems').doOnce(function(){

    // realizar algo

});
```

Este consejo es especialmente aplicable para widgets de jQuery UI, los cuales poseen mucha carga incluso cuando la selección no contiene elementos.



## Definición de Variables

Las variables pueden ser definidas en una sola declaración en lugar de varias.

```javascript
// antiguo
var test = 1;
var test2 = function() { ... };
var test3 = test2(test);

// mejor forma
var test = 1,
    test2 = function() { ... },
    test3 = test2(test);
```

En funciones autoejecutables, las definiciones de variables pueden pasarse todas juntas.

```javascript
(function(foo, bar) { ... })(1, 2);
```



## Condicionales

```javascript
// antiguo
if (type == 'foo' || type == 'bar') { ... }

// mejor
if (/^(foo|bar)$/.test(type)) { ... }

// búsqueda en objeto literal
if (({ foo : 1, bar : 1 })[type]) { ... }
```



## No Tratar a jQuery como si fuera una Caja Negra

Utilice el código fuente de la biblioteca como si fuera su documentación — guarde el enlace [http://bit.ly/jqsource](http://bit.ly/jqsource) como marcador para tener de referencia.



