# Extensiones



## ¿Qué es una Extensión?

Una extensión de jQuery es simplemente un nuevo método que se utilizará para extender el prototipo (*prototype*) del objeto jQuery. Cuando se
extiende el prototipo, todos los objetos jQuery hereden los métodos añadidos. Por lo tanto, cuando se realiza una llamada `jQuery()`, es creado un nuevo objeto jQuery con todos los métodos heredados.

El objetivo de una extensión es realizar una acción utilizando una colección de elementos, de la misma forma que lo hacen, por ejemplo, los
métodos `fadeOut` o `addClass` de la biblioteca.

Usted puede realizar sus propias extensiones y utilizarlas de forma privada en su proyecto o también puede publicarlas para que otras personas le saquen provecho.



## Crear una Extensión Básica

El código para realizar una extensión básica es la siguiente:

```javascript
(function($){
    $.fn.myNewPlugin = function() {
        return this.each(function(){
            // realizar algo
        });
    };
})(jQuery);
```

La extensión del prototipo del objeto jQuery ocurre en la siguiente línea:

```javascript
$.fn.myNewPlugin = function() { //...
```

La cual es encerrada en una función autoejecutable:

```javascript
(function($){
    //...
})(jQuery);
```

Esta posee la ventaja de crear un alcance "privado", permitiendo utilizar el signo dolar sin tener la preocupación de que otra biblioteca también este utilizando dicho signo.

Por ahora, internamente la extensión queda:

```javascript
$.fn.myNewPlugin = function() {
    return this.each(function(){
        // realizar algo
    });
};
```

Dentro de ella, la palabra clave `this` hace referencia al objeto jQuery en donde la extensión es llamada.

```javascript
var somejQueryObject = $('#something');

$.fn.myNewPlugin = function() {
    alert(this === somejQueryObject);
};

somejQueryObject.myNewPlugin(); // muestra un alerta con 'true'
```

El objeto jQuery, normalmente, contendrá referencias a varios elementos DOM, es por ello que a menudo se los refiere como una colección.

Para interactuar con la colección de elementos, es necesario realizar un bucle, el cual se logra fácilmente con el método `each()`:

```javascript
$.fn.myNewPlugin = function() {
    return this.each(function(){

    });
};
```

Al igual que otros métodos, `each()` devuelve un objeto jQuery, permitiendo utilizar el encadenado de métodos (`$(...).css().attr()...`). Para no romper esta convención, la extensión a crear deberá devolver el objeto `this`, para permitir seguir con el encadenamiento. A continuación se muestra un pequeño ejemplo:

```javascript
(function($){
    $.fn.showLinkLocation = function() {
        return this.filter('a').each(function(){
            $(this).append(
                ' (' + $(this).attr('href') + ')'
            );
        });
    };
})(jQuery);

// Ejemplo de utilización:
$('a').showLinkLocation();
```

La extensión modificará todos los enlaces dentro de la colección de elementos y les añadirá el valor de su atributo `href` entre paréntesis.

```javascript
<!-- Antes que la extensión sea llamada: -->
<a href="page.html">Foo</a>

<!-- Después que la extensión es llamada: -->
<a href="page.html">Foo (page.html)</a>
```

También es posible optimizar la extensión:

```javascript
(function($){
    $.fn.showLinkLocation = function() {
        return this.filter('a').append(function(){
              return ' (' + this.href + ')';
        });
    };
})(jQuery);
```

El método `append` permite especificar una función de devolución de llamada, y el valor devuelto determinará que es lo que se añadirá a cada elemento. Note también que no se utiliza el método `attr`, debido a que la API nativa del DOM permite un fácil acceso a la propiedad `href`.

A continuación se muestra otro ejemplo de extensión. En este caso, no se requiere realizar un bucle en cada elemento ya que se delega la funcionalidad directamente en otro método jQuery:

```javascript
(function($){
    $.fn.fadeInAndAddClass = function(duration, className) {
        return this.fadeIn(duration, function(){
            $(this).addClass(className);
        });
    };
})(jQuery);

// Ejemplo de utilización:
$('a').fadeInAndAddClass(400, 'finishedFading');
```



## Encontrar y Evaluar Extensiones

Uno de los aspectos más populares de jQuery es la diversidad de extensiones que existen.

Sin embargo, la calidad entre extensiones puede variar enormemente. Muchas son intensivamente probadas y bien mantenidas, pero otras son creadas de forma apresurada y luego ignoradas, sin seguir buenas prácticas.

Google es la mejor herramienta para encontrar extensiones (aunque el equipo de jQuery este trabajando para mejorar su repositorio de extensiones). Una vez encontrada la extensión, posiblemente quiera consultar la lista de correos de jQuery o el canal IRC \#jquery para obtener la opinión de otras personas sobre dicha extensión.

Asegúrese que la extensión este bien documentada, y que se ofrecen ejemplos de su utilización. También tenga cuidado con las extensiones que realizan más de lo que necesita, estas pueden llegar a sobrecargar su página. Para más consejos sobre como detectar una extensión mediocre, puede leer el artículo (en inglés) [Signs of a poorly written jQuery plugin](http://remysharp.com/2010/06/03/signs-of-a-poorly-written-jquery-plugin/) por Remy Sharp.

Una vez seleccionada la extensión, necesitará añadirla a su página. Primero, descargue la extensión, descomprímala (si es necesario) y muévala a la carpeta de su aplicación. Finalmente insértela utilizando el elemento script (luego de la inclusión de jQuery).



## Escribir Extensiones

A veces, desee realizar una funcionalidad disponible en todo el código, por ejemplo, un método que pueda ser llamado desde una selección el cual realice una serie de operaciones.

La mayoría de las extensiones son métodos creados dentro del espacio de nombres `$.fn`. jQuery garantiza que un método llamado sobre el objeto jQuery sea capaz de acceder a dicho objeto a través de `this`. En contrapartida, la extensión debe garantizar de devolver el mismo objeto recibido (a menos que se especifique lo contrario).

A continuación se muestra un ejemplo:


**Crear una extensión para añadir y remover una clase en un elemento al suceder el evento hover**

```javascript
// definición de la extensión
(function($){
    $.fn.hoverClass = function(c) {
        return this.hover(
            function() { $(this).toggleClass(c); }
        );
    };
})(jQuery);

// utilizar la extensión
$('li').hoverClass('hover');
```

Para más información sobre el desarrollo de extensiones, puede consultar el artículo (en inglés) [A Plugin Development Pattern](http://www.learningjquery.com/2007/10/a-plugin-development-pattern) de Mike Alsup. En dicho artículo, se desarrolla una extensión llamada `$.fn.hilight`, la cual provee soporte para la extensión [metadata](http://plugins.jquery.com/project/metadata) (en caso de estar presente) y provee un método descentralizado para establecer opciones globales o de instancias de la extensión.


**El patrón de desarrollo de extensiones para jQuery explicado por Mike Alsup**

```javascript
//
// crear una clausura
//
(function($) {
  //
  // definición de la extensión
  //
  $.fn.hilight = function(options) {
    debug(this);
    // generación de las opciones principales antes de interactuar
    var opts = $.extend({}, $.fn.hilight.defaults, options);
    // se iteractua y formatea cada elemento
    return this.each(function() {
      $this = $(this);
      // generación de las opciones especificas de cada elemento
      var o = $.meta ? $.extend({}, opts, $this.data()) : opts;
      // actualización de los estilos de cada elemento
      $this.css({
        backgroundColor: o.background,
        color: o.foreground
      });
      var markup = $this.html();
      // se llama a la función de formateo
      markup = $.fn.hilight.format(markup);
      $this.html(markup);
    });
  };
  //
  // función privada para realizar depuración
  //
  function debug($obj) {
    if (window.console && window.console.log)
      window.console.log('hilight selection count: ' + $obj.size());
  };
  //
  // definir y exponer la función de formateo
  //
  $.fn.hilight.format = function(txt) {
    return '<strong>' + txt + '</strong>';
  };
  //
  // opciones predeterminadas
  //
  $.fn.hilight.defaults = {
    foreground: 'red',
    background: 'yellow'
  };
//
// fin de la clausura
//
})(jQuery);
```



## Escribir Extensiones con Mantenimiento de Estado Utilizando Widget Factory de jQuery UI


> **Nota**
>
> Esta sección esta basada, con permiso del autor, en el artículo [Building Stateful jQuery Plugins](http://blog.nemikor.com/2010/05/15/building-stateful-jquery-plugins/) de Scott Gonzalez.


Mientras que la mayoría de las extensiones para jQuery son sin mantenimiento de estado (en inglés *stateless*) — es decir, extensiones que se ejecutan solamente sobre un elemento, siendo esa su única interacción — existe un gran conjunto de funcionalidades que no se aprovechan en el patrón básico con que se desarrollan las extensiones.

Con el fin de llenar ese vacío, jQuery UI ([jQuery User Interface](http://jqueryui.com/)) ha implementado un sistema más avanzado de extensiones. Este sistema permite manejar estados y admite múltiples funciones para ser expuestas en una única extensión. Dicho sistema es llamado *widget factory* y forma parte de la versión 1.8 de jQuery UI a través de `jQuery.widget`, aunque también puede ser utilizado sin depender de jQuery UI.

Para demostrar las capacidades de *widget factory*, se creará una extensión que tendrá como funcionalidad ser una barra de progreso.

Por ahora, la extensión solo permitirá establecer el valor de la barra de progreso una sola vez. Esto se realizará llamando a `jQuery.widget` con dos parámetros: el nombre de la extensión a crear y un objeto literal que contendrá las funciones soportadas por la extensión. Cuando la extensión es llamada, una instancia de ella es creada y todas las funciones se ejecutaran en el contexto de esa instancia.

Existen dos importantes diferencias en comparación con una extensión estándar de jQuery: En primer lugar, el contexto es un objeto, no un elemento DOM. En segundo lugar, el contexto siempre es un único objeto, nunca una colección.


**Una simple extensión con mantenimiento de estado utilizando widget factory de jQuery UI**

```javascript
$.widget("nmk.progressbar", {
    _create: function() {
        var progress = this.options.value + "%";
        this.element
            .addClass("progressbar")
            .text(progress);
    }
});
```

El nombre de la extensión debe contener un espacio de nombres, en este caso se utiliza `nmk`. Los espacios de nombres tienen una limitación de un solo nivel de profundidad — es decir que por ejemplo, no es posible utilizar `nmk.foo`. Como se puede ver en el ejemplo, *widget factory* provee dos propiedades para ser utilizadas. La primera, `this.element` es un objeto jQuery que contiene exactamente un elemento. En caso que la extensión sea ejecutada en más de un elemento, una instancia separada de la extensión será creada por cada elemento y cada una tendrá su propio `this.element`. La segunda propiedad, `this.options`, es un conjunto de pares clave/valor con todas las opciones de la extensión. Estas opciones pueden pasarse a la extensión como se muestra a continuación:


> **Nota**
>
> Cuando esté realizando sus propias extensiones es recomendable utilizar su propio espacio de nombres, ya que deja en claro de donde proviene la extensión y si es parte de una colección mayor. Por otro lado, el espacio de nombres `ui` está reservado para las extensiones oficiales de jQuery UI.


**Pasar opciones al widget**

```javascript
$("<div></div>")
    .appendTo( "body" )
    .progressbar({ value: 20 });
```

Cuando se llama a `jQuery.widget` se extiende a jQuery añadiendo el método a `jQuery.fn` (de la misma forma que cuando se crea una extensión estándar). El nombre de la función que se añade esta basado en el nombre que se pasa a `jQuery.widget`, sin el espacio de nombres (en este caso el nombre será `jQuery.fn.progressbar`).

Como se muestra a continuación, es posible especificar valores predeterminados para cualquier opción. Estos valores deberían basarse en la utilización más común de la extensión.


**Establecer opciones predeterminadas para un widget**

```javascript
$.widget("nmk.progressbar", {
    // opciones predeterminadas
    options: {
        value: 0
    },

    _create: function() {
        var progress = this.options.value + "%";
        this.element
            .addClass( "progressbar" )
            .text( progress );
    }
});
```



### Añadir Métodos a un Widget

Ahora que es posible inicializar la extensión, es necesario añadir la habilidad de realizar acciones a través de métodos definidos en la extensión. Para definir un método en la extensión es necesario incluir la función en el objeto literal que se pasa a `jQuery.widget`. También es posible definir métodos "privados" anteponiendo un guión bajo al nombre de la función.

**Crear métodos en el Widget**

```javascript
$.widget("nmk.progressbar", {
    options: {
        value: 0
    },

    _create: function() {
        var progress = this.options.value + "%";
        this.element
            .addClass("progressbar")
            .text(progress);
    },

    // crear un método público
    value: function(value) {
        // no se pasa ningún valor, entonces actúa como método obtenedor
        if (value === undefined) {
            return this.options.value;
        // se pasa un valor, entonces actúa como método establecedor
        } else {
            this.options.value = this._constrain(value);
            var progress = this.options.value + "%";
            this.element.text(progress);
        }
    },

    // crear un método privado
    _constrain: function(value) {
        if (value > 100) {
            value = 100;
        }
        if (value < 0) {
            value = 0;
        }
        return value;
    }
});
```

Para llamar a un método en una instancia de la extensión, se debe pasar  el nombre de dicho método a la extensión. En caso que se llame a un método que acepta parámetros, estos se deben pasar a continuación del nombre del método.


**Llamar a métodos en una instancia de extensión**

```javascript
var bar = $("<div></div>")
    .appendTo("body")
    .progressbar({ value: 20 });

// obtiene el valor actual
alert(bar.progressbar("value"));

// actualiza el valor
bar.progressbar("value", 50);

// obtiene el valor nuevamente
alert(bar.progressbar("value"));
```


> **Nota**
>
> Ejecutar métodos pasando el nombre del método a la misma función jQuery que se utiliza para inicializar la extensión puede parecer extraño, sin embargo es realizado así para prevenir la "contaminación" del espacio de nombres de jQuery manteniendo al mismo tiempo la capacidad de llamar a métodos en cadena.



### Trabajar con las Opciones del Widget

Uno de los métodos disponibles automáticamente para la extensión es `option`. Este método permite obtener y establecer opciones después de la inicialización y funciona exactamente igual que los métodos *attr* y *css* de jQuery: pasando únicamente un nombre como argumento el método funciona como obtenedor, mientras que pasando uno o más conjuntos de nombres y valores el método funciona como establecedor. Cuando es utilizado como método obtenedor, la extensión devolverá el valor actual de la opción correspondiente al nombre pasado como argumento. Por otro lado, cuando es utilizado como un método establecedor, el método `_setOption` de la extensión será llamado por cada opción que se desea establecer.

**Responder cuando una opción es establecida**

```javascript
$.widget("nmk.progressbar", {
    options: {
        value: 0
    },

    _create: function() {
        this.element.addClass("progressbar");
        this._update();
    },

    _setOption: function(key, value) {
        this.options[key] = value;
        this._update();
    },

    _update: function() {
        var progress = this.options.value + "%";
        this.element.text(progress);
    }
});
```



### Añadir Funciones de Devolución de Llamada

Uno de las maneras más fáciles de extender una extensión es añadir funciones de devolución de llamada, para que de esta forma el usuario puede reaccionar cuando el estado de la extensión cambie. A continuación se mostrará como añadir una función de devolución de llamada a la extensión creada para indicar cuando la barra de progreso haya alcanzado el 100%. El método `_trigger` obtiene tres parámetros: el nombre de la función de devolución, el objeto de evento nativo que inicializa la función de devolución y un conjunto de información relevante al evento. El nombre de la función de devolución es el único parámetro obligatorio, pero los otros pueden ser muy útiles si el usuario desea implementar funcionalidades personalizadas.


**Proveer funciones de devolución de llamada**

```javascript
$.widget("nmk.progressbar", {
    options: {
        value: 0
    },

    _create: function() {
        this.element.addClass("progressbar");
        this._update();
    },

    _setOption: function(key, value) {
        this.options[key] = value;
        this._update();
    },

    _update: function() {
        var progress = this.options.value + "%";
        this.element.text(progress);
        if (this.options.value == 100) {
            this._trigger("complete", null, { value: 100 });
        }
    }
});
```

Las funciones de devolución son esencialmente sólo opciones adicionales, por lo cual, pueden ser establecidas como cualquier otra opción. Cada vez que una función de devolución es ejecutada, un evento correspondiente se activa también. El tipo de evento se determina mediante la concatenación del nombre de la extensión y el nombre de la función de devolución. Dicha función y evento reciben dos mismos parámetros: un objeto de evento y un conjunto de información relevante al evento.

Si la extensión tendrá alguna funcionalidad que podrá ser cancelada por el usuario, la mejor manera de hacerlo es creando funciones de devolución cancelables. El usuario podrá cancelar una función de devolución o su evento asociado de la misma manera que se cancela cualquier evento nativo: llamando a `event.preventDefault()` o utilizando `return false`.


**Vincular a eventos del widget**

```javascript
var bar = $("<div></div>")
    .appendTo("body")
    .progressbar({
        complete: function(event, data) {
            alert( "Función de devolución" );
        }
    })
    .on("progressbarcomplete", function(event, data) {
        alert("El valor de la barra de progreso es " + data.value);
    });

bar.progressbar("option", "value", 100);
```


**En profundidad: Widget Factory**

Cuando se llama a `jQuery.widget`, ésta crea una función constructora para la extensión y establece el objeto literal que se pasa como el prototipo para todas las instancias de la extensión. Todas las funcionalidades que automáticamente se añaden a la extensión provienen del prototipo base del widget, el cual es definido como `jQuery.Widget.prototype`. Cuando una instancia de la extensión es creada, es guardada en el elemento DOM original utilizando `jQuery.data`, con el nombre de la extensión como palabra clave.

Debido a que la instancia de la extensión esta directamente vinculada al elemento DOM, es posible acceder a la instancia de la extensión de forma directa. Esto permite llamar a métodos directamente en la instancia de la extensión en lugar de pasar el nombre del método como una cadena de caracteres, dando la posibilidad de acceder a las propiedades de la extensión.

```javascript
var bar = $("<div></div>")
    .appendTo("body")
    .progressbar()
    .data("progressbar" );

// llamar a un método directamente en la instancia de la extensión
bar.option("value", 50);

// acceder a propiedades en la instancia de la extensión
alert(bar.options.value);
```

Uno de los mayores beneficios de tener un constructor y un prototipo para una extensión es la facilidad de extender la extensión. El hecho de añadir o cambiar métodos en el prototipo de la extensión, permite también modificarlos en todas las instancias de la extensión. Por ejemplo, si deseamos añadir un método a la extensión de barra de progreso para permitir restablecer el progreso a 0%, es posible hacerlo añadiendo este método al prototipo y automáticamente estará disponible para ser llamada desde cualquier instancia de la extensión.

```javascript
$.nmk.progressbar.prototype.reset = function() {
    this._setOption("value", 0);
};
```



### Limpieza

En algunos casos, tendrá sentido permitir a los usuarios aplicar y desaplicar la extensión. Esto es posible hacerlo a través del método `destroy`. Con dicho método, es posible deshacer todo lo realizado con la extensión. También éste es llamado automáticamente si el elemento vinculado a la extensión es eliminado del DOM (por lo cual también es posible utilizarlo para la "recolección de basura"). El método `destroy` predeterminado remueve el vínculo entre el elemento DOM y la instancia de la extensión


**Añadir un método destroy al widget**

```javascript
$.widget( "nmk.progressbar", {
    options: {
        value: 0
    },

    _create: function() {
        this.element.addClass("progressbar");
        this._update();
    },

    _setOption: function(key, value) {
        this.options[key] = value;
        this._update();
    },

    _update: function() {
        var progress = this.options.value + "%";
        this.element.text(progress);
        if (this.options.value == 100 ) {
            this._trigger("complete", null, { value: 100 });
        }
    },

    destroy: function() {
        this.element
            .removeClass("progressbar")
            .text("");

        // llama a la función base destroy
        $.Widget.prototype.destroy.call(this);
    }
});
```



### Conclusión

La utilización de *Widget factory* es solo una manera de crear extensiones con mantenimiento de estado. Existen algunos modelos diferentes que pueden ser utilizados y cada uno posee sus ventajas y desventajas. *Widget factory* resuelve muchos problemas comunes, mejora significativamente la productividad y la reutilización de código.



## Ejercicios



### Realizar una Tabla Ordenable

Para este ejercicio, la tarea es identificar, descargar e implementar una extensión que permita ordenar la tabla existente en la página index.html. Cuando esté listo, todas las columnas de la tabla deben poder ser ordenables.



### Escribir una Extensión Para Cambiar el Color de Fondo en Tablas

Abra el archivo `/ejercicios/index.html` en el navegador. Realice el ejercicio utilizando el archivo `/ejercicios/js/stripe.js`. La tarea es escribir una extensión llamada "stripe" la cual podrá ser llamada desde cualquier elemento table y deberá cambiar el color de fondo de las filas impares en el cuerpo de la tabla. El color podrá ser especificado como parámetro de la extensión.

```javascript
$('#myTable').stripe('#cccccc');
```

No olvide de devolver la tabla para que otros métodos puedan ser encadenados luego de la llamada a la extensión.



