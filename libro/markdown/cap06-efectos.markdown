# Efectos



## Introducción

Con jQuery, agregar efectos a una página es muy fácil. Estos efectos poseen una configuración predeterminada pero también es posible proveerles parámetros personalizados. Además es posible crear animaciones particulares estableciendo valores de propiedades CSS.

Para una completa documentación sobre los diferentes tipos de efectos puede visitar la sección `effects`: [http://api.jquery.com/category/effects/](http://api.jquery.com/category/effects/).



## Efectos Incorporados en la Biblioteca

Los efectos más utilizado ya vienen incorporados dentro de la biblioteca en forma de métodos:

 $.fn.show
  ~ Muestra el elemento seleccionado.

 $.fn.hide
  ~ Oculta el elemento seleccionado.

 $.fn.fadeIn
  ~ De forma animada, cambia la opacidad del elemento seleccionado al 100%.

 $.fn.fadeOut
  ~ De forma animada, cambia la opacidad del elemento seleccionado al 0

 $.fn.slideDown
  ~ Muestra el elemento seleccionado con un movimiento de deslizamiento vertical.

 $.fn.slideUp
  ~ Oculta el elemento seleccionado con un movimiento de deslizamiento vertical.

 $.fn.slideToggle
  ~ Muestra o oculta el elemento seleccionado con un movimiento de deslizamiento vertical, dependiendo si actualmente el elemento está visible o no.


**Uso básico de un efecto incorporado**

```javascript
$('h1').show();
```



### Cambiar la Duración de los Efectos

Con la excepción de `$.fn.show` y `$.fn.hide`, todos los métodos tienen una duración predeterminada de la animación en 400ms. Este valor es posible cambiarlo.


**Configurar la duración de un efecto**

```javascript
$('h1').fadeIn(300);      // desvanecimiento en 300ms
$('h1').fadeOut('slow');  // utilizar una definición de velocidad interna
```



#### jQuery.fx.speeds

jQuery posee un objeto en `jQuery.fx.speeds` el cual contiene la velocidad predeterminada para la duración de un efecto, así como también los valores para las definiciones *"slow"* y *"fast"*.

```javascript
speeds: {
    slow: 600,
    fast: 200,
    // velocidad predeterminada
    _default: 400
}
```

Por lo tanto, es posible sobrescribir o añadir nuevos valores al objeto. Por ejemplo, puede que quiera cambiar el valor predeterminado del efecto o añadir una velocidad personalizada.


**Añadir velocidades personalizadas a `jQuery.fx.speeds`**

```javascript
jQuery.fx.speeds.muyRapido = 100;
jQuery.fx.speeds.muyLento = 2000;
```



### Realizar una Acción Cuando un Efecto fue Ejecutado

A menudo, querrá ejecutar una acción una vez que la animación haya terminado — ya que si ejecuta la acción antes que la animación haya acabado, puede llegar a alterar la calidad del efecto o afectar a los elementos que forman parte de la misma. [Definición: *Las funciones de devolución de llamada* (en inglés *callback functions*) proveen una forma para ejecutar código una vez que un evento haya terminado.] En este caso, el evento que responderá a la función será la conclusión de la animación. Dentro de la función de devolución, la palabra clave `this` hace referencia al elemento en donde el efecto fue ejecutado y al igual que sucede con los eventos, es posible transformarlo a un objeto jQuery utilizando `$(this)`.


**Ejecutar cierto código cuando una animación haya concluido**

```javascript
$('div.old').fadeOut(300, function() { $(this).remove(); });
```

Note que si la selección no retorna ningún elemento, la función nunca se ejecutará. Este problema lo puede resolver comprobando si la selección devuelve algún elemento; y en caso que no lo haga, ejecutar la función de devolución inmediatamente.


**Ejecutar una función de devolución incluso si no hay elementos para animar**

```javascript
var $thing = $('#nonexistent');

var cb = function() {
    console.log('realizado');
};

if ($thing.length) {
    $thing.fadeIn(300, cb);
} else {
    cb();
}
```



## Efectos Personalizados con `$.fn.animate`

Es posible realizar animaciones en propiedades CSS utilizando el método `$.fn.animate`. Dicho método permite realizar una animación estableciendo valores a propiedades CSS o cambiando sus valores actuales.


**Efectos personalizados con `$.fn.animate`**

```javascript
$('div.funtimes').animate(
    {
        left : "+=50",
        opacity : 0.25
    },
    300, // duration
    function() { console.log('realizado'); // función de devolución de llamada
});
```


> **Nota**
>
> Las propiedades relacionadas al color no pueden ser animadas utilizando el método `$.fn.animate`, pero es posible hacerlo a través de la extensión [color plugin](http://plugins.jquery.com/files/jquery.color.js.txt). Más adelante en el libro de discutirá la utilización de extensiones.



### Easing

[Definición: El concepto de *Easing* describe la manera en que un efecto ocurre — es decir, si la velocidad durante la animación es constante o no.] jQuery incluye solamente dos métodos de easing: *swing* y *linear*. Si desea transiciones más naturales en las animaciones, existen varias extensiones que lo permiten.

A partir de la versión 1.4 de la biblioteca, es posible establecer el tipo de transición por cada propiedad utilizando el método `$.fn.animate`.


**Transición de easing por cada propiedad**

```javascript
$('div.funtimes').animate(
    {
        left : [ "+=50", "swing" ],
        opacity : [ 0.25, "linear" ]
    },
    300
);
```

Para más detalles sobre las opciones de easing, consulte [http://api.jquery.com/animate/](http://api.jquery.com/animate/).



## Control de los Efectos

jQuery provee varias herramientas para el manejo de animaciones.

 $.fn.stop
  ~ Detiene las animaciones que se están ejecutando en el elemento seleccionado.

 $.fn.delay
  ~ Espera un tiempo determinado antes de ejecutar la próxima animación.

```javascript
$('h1').show(300).delay(1000).hide(300);
```

 jQuery.fx.off
  ~ Si el valor es verdadero (*true*), no existirán transiciones para las animaciones; y a los elementos se le establecerá el estado final de la animación. Este método puede ser especialmente útil cuando se esta trabajando con navegadores antiguos.



## Ejercicios



### Mostrar Texto Oculto

Abra el archivo `/ejercicios/index.html` en el navegador. Realice el ejercicio utilizando el archivo `/ejercicios/js/blog.js`. La tarea es añadir alguna interactividad a la sección blog de la página:

-   al hacer click en alguno de los titulares del *div #blog*, se debe mostrar el párrafo correspondiente con un efecto de deslizamiento;

-   al hacer click en otro titular, se debe ocultar el párrafo mostrado con un efecto de deslizamiento y mostrar nuevamente el párrafo correspondiente también con un efecto de deslizamiento. Ayuda: No se olvide de utilizar el selector `:visible`.



### Crear un Menú Desplegable

Abra el archivo `/ejercicios/index.html` en el navegador. Realice el ejercicio utilizando el archivo `/ejercicios/js/navigation.js`. La tarea es poder desplegar los ítems del menú superior de la página:

-   al pasar el puntero del ratón por encima de un ítem del menú, se debe mostrar su submenú en caso que exista;

-   al no estar más encima de un ítem, el submenú se debe ocultar.

Para poder realizarlo, utilice el método `$.fn.hover` para añadir o remover una clase en el submenú para poder controlar si debe estar oculto o visible (El archivo `/ejercicios/css/styles.css` incluye una clase "hover" para este propósito)



### Crear un Slideshow

Abra el archivo `/ejercicios/index.html` en el navegador. Realice el ejercicio utilizando el archivo `/ejercicios/js/slideshow.js`. La tarea es añadir un slideshow a la página con JavaScript.

1.  Mover el elemento *#slideshow* a la parte superior de la página.

2.  Escribir un código que permita mostrar los ítems de forma cíclica, mostrando un ítem por unos segundos, luego ocultándolo con un efecto *fade out* y mostrando el siguiente con un efecto *fade in.

3.  Una vez llegado al último ítem de la lista, comenzar de nuevo con el primero.

Para un desafío mayor, realice un área de navegación por debajo del slideshow que muestre cuantas imágenes existen y en cual se encuentra (ayuda: $.fn.prevAll` puede resultar útil).



