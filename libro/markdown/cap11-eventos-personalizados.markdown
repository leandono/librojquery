# Eventos Personalizados



## Introducción a los Eventos Personalizados

Todos estamos familiarizados con los eventos básicos — `click`, `mouseover`, `focus`, `blur`, `submit`, etc. — que surgen a partir de la interacción del usuario con el navegador.

Los eventos personalizados permiten conocer el mundo de la programación orientada a eventos (en inglés *event-driven programming*). En este capítulo, se utilizará el sistema de eventos personalizados de jQuery para crear una simple aplicación de búsqueda en *Twitter*.

En un primer momento puede ser difícil entender el requisito de utilizar eventos personalizados, ya que los eventos convencionales permiten satisfacer todas las necesidades. Sin embargo, los eventos personalizados ofrecen una nueva forma de pensar la programación en JavaScript. En lugar de enfocarse en el elemento que ejecuta una acción, los eventos personalizados ponen la atención en el elemento en donde la acción va a ocurrir. Este concepto brinda varios beneficios:

-   los comportamientos del elemento objetivo pueden ser ejecutados por diferentes elementos utilizando el mismo código;

-   los comportamientos pueden ser ejecutados en múltiples, similares elementos objetivos a la vez;

-   los comportamientos son asociados de forma más clara con el elemento objetivo, haciendo que el código sea más fácil de leer y mantener.

Un ejemplo es la mejor forma de explicar el asunto. Suponga que posee una lámpara incandescente en una habitación de una casa. La lámpara actualmente esta encendida. La misma es controlada por dos interruptores de tres posiciones y un *clapper* (interruptor activado por aplausos):

```xml
<div class="room" id="kitchen">
    <div class="lightbulb on"></div>
    <div class="switch"></div>
    <div class="switch"></div>
    <div class="clapper"></div>
</div>
```

Ejecutando el *clapper* o alguno de los interruptores, el estado de la lampara cambia. A los interruptores o al *clapper* no le interesan si la lámpara esta prendida o apagada, tan solo quieren cambiar su estado

Sin la utilización de eventos personalizados, es posible escribir la rutina de la siguiente manera:

```javascript
$('.switch, .clapper').click(function() {
    var $light = $(this).parent().find('.lightbulb');
    if ($light.hasClass('on')) {
        $light.removeClass('on').addClass('off');
    } else {
        $light.removeClass('off').addClass('on');
    }
});
```

Por otro lado, utilizando eventos personalizados, el código queda así:

```javascript
$('.lightbulb').on('changeState', function(e) {
    var $light = $(this);
    if ($light.hasClass('on')) {
        $light.removeClass('on').addClass('off');
    } else {
        $light.removeClass('off').addClass('on');
    }
});

$('.switch, .clapper').click(function() {
    $(this).parent().find('.lightbulb').trigger('changeState');
});
```

Algo importante ha sucedido: el comportamiento de la lámpara se ha movido, antes estaba en los interruptores y en el *clapper*, ahora se encuentra en la misma lámpara.

También es posible hacer el ejemplo un poco más interesante. Suponga que se ha añadido otra habitación a la casa, junto con un interruptor general, como se muestra a continuación:

```javascript
<div class="room" id="kitchen">
    <div class="lightbulb on"></div>
    <div class="switch"></div>
    <div class="switch"></div>
    <div class="clapper"></div>
</div>
<div class="room" id="bedroom">
    <div class="lightbulb on"></div>
    <div class="switch"></div>
    <div class="switch"></div>
    <div class="clapper"></div>
</div>
<div id="master_switch"></div>
```

Si existe alguna lámpara prendida en la casa, es posible apagarlas a través del interruptor general, de igual forma si existen luces apagadas, es posible prenderlas con dicho interruptor. Para realizar esta tarea, se agregan dos eventos personalizados más a la lámpara: `turnOn` y `turnOff`. A través de una lógica en el evento `changeState` se decide qué evento personalizado utilizar:

```javascript
$('.lightbulb')
    .on('changeState', function(e) {
        var $light = $(this);
        if ($light.hasClass('on')) {
            $light.trigger('turnOff');
        } else {
            $light.trigger('turnOn');
        }
    })
    .on('turnOn', function(e) {
        $(this).removeClass('off').addClass('on');
    })
    .on('turnOff', function(e) {
        $(this).removeClass('off').addClass('on');
    });

$('.switch, .clapper').click(function() {
    $(this).parent().find('.lightbulb').trigger('changeState');
});

$('#master_switch').click(function() {
    if ($('.lightbulb.on').length) {
        $('.lightbulb').trigger('turnOff');
    } else {
        $('.lightbulb').trigger('turnOn');
    }
});
```

Note como el comportamiento del interruptor general se ha vinculado al interruptor general mientras que el comportamiento de las lámparas pertenece a las lámparas.


> **Nota**
>
> Si esta acostumbrado a la programación orientada a objetos, puede resultar útil pensar de los eventos personalizados como métodos de objetos. En términos generales, el objeto al que pertenece el método se crea a partir del selector jQuery. Vincular el evento personalizado `changeState` a todos los elementos `$(‘.light’)` es similar a tener una clase llamada `Light` con un método `changeState`, y luego instanciar nuevos objetos `Light` por cada elemento.



**Recapitulación: $.fn.on y $.fn.trigger**

En el mundo de los eventos personalizados, existen dos métodos importantes de jQuery: `$.fn.on` y `$.fn.trigger`. En el capítulo dedicado a eventos se explicó la utilización de estos dos métodos para trabajar con eventos del usuario; en este capítulo es importante recordar 2 puntos:

-   el método `$.fn.on` toma como argumentos un tipo de evento y una función controladora de evento. Opcionalmente, puede recibir información asociada al evento como segundo argumento, desplazando como tercer argumento a la función controladora de evento. Cualquier información pasada estará disponible a la función controladora a través de la propiedad `data` del objeto del evento. A su vez, la función controladora recibe el objeto del evento como primer argumento;

-   el método `$.fn.trigger` toma como argumentos el tipo de evento y opcionalmente, puede tomar un vector con valores. Estos valores serán pasados a la función controladora de eventos como argumentos luego del objeto del evento.

A continuación se muestra un ejemplo de utilización de `$.fn.on` y `$.fn.trigger` en donde se utiliza información personalizada en ambos casos:

```javascript
$(document).on('myCustomEvent', { foo : 'bar' }, function(e, arg1, arg2) {
    console.log(e.data.foo); // 'bar'
    console.log(arg1); // 'bim'
    console.log(arg2); // 'baz'
});

$(document).trigger('myCustomEvent', [ 'bim', 'baz' ]);
```



### Un Ejemplo de Aplicación

Para demostrar el poder de los eventos personalizados, se desarrollará una simple herramienta para buscar en *Twitter*. Dicha herramienta ofrecerá varias maneras para que el usuario realice una búsqueda: ingresando el término a buscar en una caja de texto o consultando los "temas de moda" de *Twitter*.

Los resultados de cada término se mostrarán en un contenedor de resultados; dichos resultados podrán expandirse, colapsarse, refrescarse y removerse, ya sea de forma individual o conjunta.

El resultado final de la aplicación será el siguiente:


**Figura 11.1. La aplicación finalizada**

![La aplicación finalizada](./figuras/70415e9fffab1c47953f5264ecf722fe.png)



#### Iniciación

Se empieza con un HTML básico:

```javascript
<h1>Twitter Search</h1>
<input type="button" id="get_trends"
    value="Load Trending Terms" />

<form>
    <input type="text" class="input_text"
        id="search_term" />
    <input type="submit" class="input_submit"
        value="Add Search Term" />
</form>

<div id="twitter">
    <div class="template results">
        <h2>Search Results for
        <span class="search_term"></span></h2>
    </div>
</div>
```

El HTML posee un contenedor (#twitter) para el widget, una plantilla para los resultados (oculto con CSS) y un simple formulario en donde el usuario puede escribir el término a buscar.

Existen dos tipos de elementos en los cuales actuar: los contenedores de resultados y el contenedor *Twitter*.

Los contenedores de resultados son el corazón de la aplicación. Se creará una extensión para preparar cada contenedor una vez que éste se agrega al contenedor *Twitter*. Además, entre otras cosas, la extensión vinculará los eventos personalizados por cada contenedor y añadirá en la parte superior derecha de cada contenedor botones que ejecutarán acciones. Cada contenedor de resultados tendrá los siguientes eventos personalizados:

 refresh
  ~ Señala que la información del contenedor se esta actualizando y dispara la petición que busca los datos para el término de búsqueda.

 populate
  ~ Recibe la información JSON y la utiliza para rellenar el contenedor.

 remove
  ~ Remueve el contenedor de la página luego de que el usuario confirme la acción. Dicha confirmación puede omitirse si se pasa `true` como segundo argumento del controlador de evento. El evento además remueve el término asociado con el contenedor de resultados del objeto global que contiene los términos de búsqueda.

 collapse
  ~ Añade una clase al contenedor, la cual ocultará el resultado a través de CSS. Además cambiará el botón de "Colapsar" a "Expandir".

 expand
  ~ Remueve la clase del contenedor que añade el evento *collapse*. Además cambiará el botón de "Expandir" a "Colapsar".

Además, la extensión es responsable de añadir los botones de acciones al contenedor, vinculando un evento `click` a cada botón y utilizando la clase de cada ítem para determinar qué evento personalizado será ejecutado en cada contenedor de resultados.

```javascript
$.fn.twitterResult = function(settings) {
    return this.each(function() {
        var $results = $(this),
            $actions = $.fn.twitterResult.actions =
                $.fn.twitterResult.actions ||
                $.fn.twitterResult.createActions(),
            $a = $actions.clone().prependTo($results),
            term = settings.term;

        $results.find('span.search_term').text(term);

        $.each(
            ['refresh', 'populate', 'remove', 'collapse', 'expand'],
            function(i, ev) {
                $results.bind(
                    ev,
                    { term : term },
                    $.fn.twitterResult.events[ev]
                );
            }
        );

        // utiliza la clase de cada acción para determinar
        // que evento se ejecutará en el panel de resultados
        $a.find('li').click(function() {
            // pasa el elemento <li> clickeado en la función
            // para que se pueda manipular en caso de ser necesario
            $results.trigger($(this).attr('class'), [ $(this) ]);
        });
    });
};

$.fn.twitterResult.createActions = function() {
    return $('<ul class="actions" />').append(
        '<li class="refresh">Refresh</li>' +
        '<li class="remove">Remove</li>' +
        '<li class="collapse">Collapse</li>'
    );
};

$.fn.twitterResult.events = {
    refresh : function(e) {
           // indica que los resultados se estan actualizando
        var $this = $(this).addClass('refreshing');

        $this.find('p.tweet').remove();
        $results.append('<p class="loading">Loading ...</p>');

        // obtiene la información de Twitter en formato jsonp
        $.getJSON(
            'http://search.twitter.com/search.json?q=' +
                escape(e.data.term) + '&rpp=5&callback=?',
            function(json) {
                $this.trigger('populate', [ json ]);
            }
        );
    },

    populate : function(e, json) {
        var results = json.results;
        var $this = $(this);

        $this.find('p.loading').remove();

        $.each(results, function(i,result) {
            var tweet = '<p class="tweet">' +
                '<a href="http://twitter.com/' +
                result.from_user +
                '">' +
                result.from_user +
                '</a>: ' +
                result.text +
                ' <span class="date">' +
                result.created_at +
                '</span>' +
            '</p>';
            $this.append(tweet);
        });

        // indica que los resultados
        // ya se han actualizado
        $this.removeClass('refreshing');
    },

    remove : function(e, force) {
        if (
            !force &&
            !confirm('Remove panel for term ' + e.data.term + '?')
        ) {
            return;
        }
        $(this).remove();

        // indica que ya no se tendrá
        // un panel para el término
        search_terms[e.data.term] = 0;
    },

    collapse : function(e) {
        $(this).find('li.collapse').removeClass('collapse')
            .addClass('expand').text('Expand');

        $(this).addClass('collapsed');
    },

    expand : function(e) {
        $(this).find('li.expand').removeClass('expand')
            .addClass('collapse').text('Collapse');

        $(this).removeClass('collapsed');
    }
};
```

El contenedor *Twitter*, posee solo dos eventos personalizados:

 getResults
  ~ Recibe un término de búsqueda y comprueba si ya no existe un contenedor de resultados para dicho término. En caso de no existir, añade un contenedor utilizando la plantilla de resultados, lo configura utilizando la extensión `$.fn.twitterResult` (mostrada anteriormente) y luego ejecuta el evento `refresh` con el fin de cargar correctamente los resultados. Finalmente, guarda el término buscado para no tener volver a pedir los datos sobre la búsqueda.

 getTrends
  ~ Consulta a *Twitter* el listado de los 10 primeros "términos de moda", interactúa con ellos y ejecuta el evento `getResults` por cada uno, de tal modo que añade un contenedor de resultados por cada término.

Vinculaciones en el contenedor *Twitter*:

```javascript
$('#twitter')
    .on('getResults', function(e, term) {
        // se comprueba que ya no exista una caja para el término
        if (!search_terms[term]) {
            var $this = $(this);
            var $template = $this.find('div.template');

            // realiza una copia de la plantilla
            // y la inserta como la primera caja de resultados
            $results = $template.clone().
                removeClass('template').
                insertBefore($this.find('div:first')).
                twitterResult({
                    'term' : term
                });

            // carga el contenido utilizando el evento personalizado "refresh"
            // vinculado al contenedor de resultados
            $results.trigger('refresh');
            search_terms[term] = 1;
        }
    })
    .on('getTrends', function(e) {
        var $this = $(this);
        $.getJSON('http://api.twitter.com/1/trends/1.json?callback=?', function(json) {
                var trends = json[0].trends;
                $.each(trends, function(i, trend) {
                    $this.trigger('getResults', [ trend.name ]);
                });
            });
    });
```

Hasta ahora, se ha escrito una gran cantidad de código que no realiza nada, lo cual no esta mal. Se han especificado todos los comportamientos que se desean para los elementos núcleos y se ha creado un sólido marco para la creación rápida de la interfaz.

A continuación, se conecta la caja de búsqueda y el botón para cargar los "Temas de moda". En la caja de texto, se captura el término ingresado y se pasa al mismo tiempo que se ejecuta el evento `getResults`. Por otro lado, haciendo click en el botón para cargar los "Temas de moda", se ejecuta el evento `getTrends`:

```javascript
$('form').submit(function(e) {
    e.preventDefault();
    var term = $('#search_term').val();
    $('#twitter').trigger('getResults', [ term ]);
});

$('#get_trends').click(function() {
    $('#twitter').trigger('getTrends');
});
```

Añadiendo botones con un ID apropiado, es posible remover, colapsar, expandir y refrescar todos los contenedores de resultados al mismo tiempo. Para el botón que remueve el contenedor, notar que se esta pasando `true` al controlador del evento como segundo argumento, indicando que no se desea una confirmación del usuario para remover el contenedor.

```javascript
$.each(['refresh', 'expand', 'collapse'], function(i, ev) {
    $('#' + ev).click(function(e) { $('#twitter div.results').trigger(ev); });
});

$('#remove').click(function(e) {
    if (confirm('Remove all results?')) {
        $('#twitter div.results').trigger('remove', [ true ]);
    }
});
```



#### Conclusión

Los eventos personalizados ofrecen una nueva manera de pensar el código: ellos ponen el énfasis en el objetivo de un comportamiento, no en el elemento que lo activa. Si se toma el tiempo desde el principio para explicar las piezas de su aplicación, así como los comportamientos que esas piezas necesitan exhibir, los eventos personalizados proveen una manera poderosa para "hablar" con esas piezas, ya sea de una en una o en masa.

Una vez que los comportamientos se han descripto, se convierte en algo trivial ejecutarlos desde cualquier lugar, lo que permite la rápida creación y experimentación de opciones de interfaz. Finalmente, los eventos personalizados también permiten mejorar la lectura del código y su mantenimiento, haciendo clara la relación entre un elemento y su comportamiento.

Puede ver la aplicación completa en los archivos `demos/custom-events/custom-events.html` y `demos/custom-events/js/custom-events.js` del material que componen este libro.



