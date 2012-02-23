# Eventos



## Introducción

jQuery provee métodos para asociar controladores de eventos (en inglés *event handlers*) a selectores. Cuando un evento ocurre, la función  provista es ejecutada.  Dentro de la función, la palabra clave this hace referencia al elemento en que el evento ocurre.

Para más detalles sobre los eventos en jQuery, puede consultar [http://api.jquery.com/category/events/](http://api.jquery.com/category/events/).

La función del controlador de eventos puede recibir un objeto. Este objeto puede ser utilizado para determinar la naturaleza del evento o, por ejemplo, prevenir el comportamiento predeterminado de éste.  Para más detalles sobre el objeto del evento, visite [http://api.jquery.com/category/events/event-object/](http://api.jquery.com/category/events/event-object/).



## Vincular Eventos a Elementos

jQuery ofrece métodos para la mayoría de los eventos — entre ellos `$.fn.click`, `$.fn.focus`{.code}, `$.fn.blur`{.code}, `$.fn.change`{.code}, etc. Estos últimos son formas reducidas del método `$.fn.bind` de jQuery. El método bind es útil para vincular (en inglés *binding*) la misma función de controlador a múltiples eventos, para cuando se desea proveer información al controlador de evento, cuando se está trabajando con eventos personalizados o cuando se desea pasar un objeto a múltiples eventos y controladores.


**Vincular un evento utilizando un método reducido**

```javascript
$('p').click(function() {
    console.log('click');
});
```


**Vincular un evento utilizando el método `$.fn.bind` method**

```javascript
$('p').bind('click', function() {
    console.log('click');
});
```


**Vincular un evento utilizando el método `$.fn.bind` con información asociada**

```javascript
$('input').bind(
    'click change',  // es posible incular múltiples eventos al elemento
    { foo : 'bar' }, // se debe pasar la información asociada como argumento

    function(eventObject) {
        console.log(eventObject.type, eventObject.data);
        // registra el tipo de evento y la información asociada { foo : 'bar' }
    }
);
```



### Vincular Eventos para Ejecutar una vez

A veces puede necesitar que un controlador particular se ejecute solo una vez — y después de eso, necesite que ninguno más se ejecute, o que se ejecute otro diferente. Para este propósito jQuery provee el método `$.fn.one`.


**Cambiar controladores utilizando el método `$.fn.one`**

```javascript
$('p').one('click', function() {
    console.log('Se clickeó al elemento por primera vez');
    $(this).click(function() { console.log('Se ha clickeado nuevamente'); });
});
```

El método `$.fn.one` es útil para situaciones en que necesita ejecutar cierto código la primera vez que ocurre un evento en un elemento, pero no en los eventos sucesivos.



### Desvincular Eventos

Para desvincular (en ingles *unbind*) un controlador de evento, puede utilizar el método `$.fn.unbind` pasándole el tipo de evento a desconectar. Si se pasó como adjunto al evento una función nombrada, es posible aislar la desconexión de dicha función pasándola como segundo argumento.


**Desvincular todos los controladores del evento click en una selección**

```javascript
$('p').unbind('click');
```


**Desvincular un controlador particular del evento click**

```javascript
var foo = function() { console.log('foo'); };
var bar = function() { console.log('bar'); };

$('p').bind('click', foo).bind('click', bar);
$('p').unbind('click', bar); // foo esta atado aún al evento click
```



### Espacios de Nombres para Eventos

Cuando se esta desarrollando aplicaciones complejas o extensiones de jQuery, puede ser útil utilizar espacios de nombres para los eventos, y de esta forma evitar que se desvinculen eventos cuando no lo desea.


**Asignar espacios de nombres a eventos**

```javascript
$('p').bind('click.myNamespace', function() { /* ... */ });
$('p').unbind('click.myNamespace');
$('p').unbind('.myNamespace'); // desvincula todos los eventos con
                               // el espacio de nombre 'myNamespace'
```



### Vinculación de Múltiples Eventos

Muy a menudo, elementos en una aplicación estarán vinculados a múltiples eventos, cada uno con una función diferente. En estos casos, es posible pasar un objeto dentro de `$.fn.bind` con uno o más pares de nombres claves/valores. Cada nombre clave será el nombre del evento mientras que cada valor será la función a ejecutar cuando ocurra el evento.


**Vincular múltiples eventos a un elemento**

```javascript
$('p').bind({
    'click': function() { console.log('clickeado'); },
    'mouseover': function() { console.log('sobrepasado'); }
});
```



> **Nota**
>
> La opción de pasar un objeto con múltiples eventos y funciones a `$.fn.bind` fue introducido en jQuery 1.4.4.



## El Objeto del Evento

Como se menciona en la introducción, la función controladora de eventos recibe un objeto del evento, el cual contiene varios métodos y propiedades. El objeto es comúnmente utilizado para prevenir la acción predeterminada del evento a través del método *preventDefault*. Sin embargo, también contiene varias propiedades y métodos útiles:

 pageX, pageY
  ~ La posición del puntero del ratón en el momento que el evento ocurrió, relativo a las zonas superiores e izquierda de la página.

 type
  ~ El tipo de evento (por ejemplo "click").

 which
  ~ El botón o tecla presionada.

 data
  ~ Alguna información pasada cuando el evento es ejecutado.

 target
  ~ El elemento DOM que inicializó el evento.

 preventDefault()
  ~ Cancela la acción predeterminada del evento (por ejemplo: seguir un enlace).

 stopPropagation()
  ~ Detiene la propagación del evento sobre otros elementos.

Por otro lado, la función controladora también tiene acceso al elemento DOM que inicializó el evento a través de la palabra clave `this`. Para convertir a dicho elemento DOM en un objeto jQuery (y poder utilizar los métodos de la biblioteca) es necesario escribir `$(this)`, como se muestra a continuación:

```javascript
var $this = $(this);
```


**Cancelar que al hacer click en un enlace, éste se siga**

```javascript
$('a').click(function(e) {
    var $this = $(this);
    if ($this.attr('href').match('evil')) {
        e.preventDefault();
        $this.addClass('evil');
    }
});
```



## Ejecución automática de Controladores de Eventos

A través del método `$.fn.trigger`, jQuery provee una manera de disparar controladores de eventos sobre algún elemento sin requerir la acción del usuario. Si bien este método tiene sus usos, no debería ser utilizado para simplemente llamar a una función que pueda ser ejecutada con un click del usuario. En su lugar, debería guardar la función que se necesita llamar en una variable, y luego pasar el nombre de la variable cuando realiza el vinculo (*binding*). De esta forma, podrá llamar a la función cuando lo desee en lugar de ejecutar `$.fn.trigger`.


**Disparar un controlador de eventos de la forma correcta**

```javascript
var foo = function(e) {
    if (e) {
        console.log(e);
    } else {
        console.log('esta ejecucción no provino desde un evento');
    }
};


$('p').click(foo);

foo(); // en lugar de realizar $('p').trigger('click')
```



## Incrementar el Rendimiento con la Delegación de Eventos

Cuando trabaje con jQuery, frecuentemente añadirá nuevos elementos a la página, y cuando lo haga, necesitará vincular eventos a dichos elementos — eventos que ya estaban vinculados a elementos en la página. En lugar de repetir la tarea cada vez que se añade un elemento, es posible utilizar la delegación de eventos para hacerlo. Con ella, podrá enlazar un evento a un elemento contenedor, y luego, cuando el evento ocurra, podrá ver en que elemento sucede. Si todo esto suena complicado, afortunadamente jQuery lo hace fácil a través de los métodos `$.fn.live` y `$.fn.delegate`.

La delegación de eventos posee algunos beneficios, incluso si no se tiene pensando añadir más elementos a la página. El tiempo requerido para enlazar controladores de eventos a cientos de elementos no es un trabajo trivial; si posee un gran conjunto de elementos, debería considerar utilizar la delegación de eventos a un elemento contenedor.


> **Nota**
>
> El método `$.fn.live` fue introducido a partir de la versión 1.3 de la biblioteca y en ese momento, solo ciertos tipos de eventos eran soportados. A partir de la versión 1.4.2, se introdujo `$.fn.delegate` el cual es preferido a $.fn.live .


**Delegar un evento utilizando `$.fn.delegate`**

```javascript
$('#myUnorderedList').delegate('li', 'click', function(e) {
    var $myListItem = $(this);
    // ...
});
```


**Delegar un Evento utilizando `$.fn.live`**

```javascript
$('#myUnorderedList li').live('click', function(e) {
    var $myListItem = $(this);
    // ...
});
```



### Desvincular Eventos Delegados

Si necesita remover eventos delegados, no puede hacerlo simplemente desvinculándolos. Para eso, utilice el método `$.fn.undelegate` para eventos conectados con `$.fn.delegate`, y `$.fn.die` para eventos conectados con `$.fn.live`. Al igual que cuando se realiza un vinculo, opcionalmente, se puede pasar el nombre de una función vinculada.


**Desvincular eventos delegados**

```javascript
$('#myUnorderedList').undelegate('li', 'click');
$('#myUnorderedList li').die('click');
```



## Funciones Auxiliares de Eventos

jQuery ofrece dos funciones auxiliares para el trabajo con eventos:



### `$.fn.hover`

El método `$.fn.hover` permite pasar una o dos funciones que se ejecutarán cuando los eventos `mouseenter` y `mouseleave` ocurran en el elemento seleccionado. Si se pasa una sola función, está será ejecutada en ambos eventos; en cambio si se pasan dos, la primera será ejecutada cuando ocurra el evento `mouseenter`, mientras que la segunda será ejecutada cuando ocurra `mouseleave`.


> **Nota**
>
> A partir de la versión 1.4 de jQuery, el método requiere obligatoriamente dos funciones.


**La función auxiliar hover**

```javascript
$('#menu li').hover(function() {
    $(this).toggleClass('hover');
});
```



### `$.fn.toggle`

Al igual que el método anterior, `$.fn.toggle` recibe dos o más funciones; cada vez que un evento ocurre, la función siguiente en la lista se ejecutará. Generalmente, `$.fn.toggle` es utilizada con solo dos funciones. En caso que utiliza más de dos funciones, tenga cuidado, ya que puede ser dificultar la depuración del código.


**La función auxiliar toggle**

```javascript
$('p.expander').toggle(
    function() {
        $(this).prev().addClass('open');
    },
    function() {
        $(this).prev().removeClass('open');
    }
);
```



## Ejercicios



### Crear una "Sugerencia" para una Caja de Ingreso de Texto

Abra el archivo `/ejercicios/index.html` en el navegador. Realice el ejericio utilizando el archivo `/ejercicios/js/inputHint.js` o trabaje directamente con Firebug. La tarea a realizar es utilizar el texto del elemento label y aplicar una "sugerencia" en la caja de ingreso de texto. Los pasos ha seguir son los siguientes:

1.  Establecer el valor del elemento *input* igual al valor del elemento *label*;

2.  Añadir la clase "hint" al elemento *input*;

3.  Remover el elemento *label*;

4.  Vincular un evento *focus* en el *input* para remover el texto de sugerencia y la clase "hint";

5.  Vincular un evento *blur* en el *input* para restaurar el texto de sugerencia y la clase "hint" en caso que no se haya ingresado algún texto.

¿Qué otras consideraciones debe considerar si se desea aplicar esta funcionalidad a un sitio real?



### Añadir una Navegación por Pestañas

Abra el archivo `/ejercicios/index.html` en el navegador. Realice el ejericio utilizando el archivo `/ejercicios/js/tabs.js` o trabaje directamente con Firebug. La tarea a realizar es crear una navegación por pestañas para los dos elementos *div.module*. Los pasos ha seguir son los siguientes:

1.  Ocultar todos los elementos *div.module*;

2.  Crear una lista desordenada antes del primer *div.module* para utilizar como pestañas;

3.  Interactuar con cada div utilizando `$.fn.each`. Por cada uno, utilizar el texto del elemento *h2* como el texto para el ítem de la lista desordenada;
4.  Vincular un evento *click* a cada ítem de la lista de forma que:

    -   Muestre el *div* correspondiente y oculte el otro;

    -   Añada la clase "current" al ítem seleccionado;

    -   Remueva la clase "current" del otro ítem de la lista;

5.  Finalmente, mostrar la primera pestaña.



