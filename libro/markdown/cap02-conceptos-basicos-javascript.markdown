# Conceptos Básicos de JavaScript



## Introducción

jQuery se encuentra escrito en JavaScript, un lenguaje de programación muy rico y expresivo.

El capítulo está orientado a personas sin experiencia en el lenguaje, abarcando conceptos básicos y problemas frecuentes que pueden presentarse al trabajar con el mismo. Por otro lado, la sección puede ser beneficiosa para quienes utilicen otros lenguajes de programación para entender las peculiaridades de JavaScript.

Si usted esta interesado en aprender el lenguaje más en profundidad, puede leer el libro *JavaScript: The Good Parts* escrito por Douglas Crockford.



## Sintaxis Básica

Comprensión de declaraciones, nombres de variables, espacios en blanco, y otras sintaxis básicas de JavaScript.


**Declaración simple de variable**

```javascript
var foo = 'hola mundo';
```


**Los espacios en blanco no tienen valor fuera de las comillas**

```javascript
var foo =         'hola mundo';
```


**Los paréntesis indican prioridad**

```javascript
2 * 3 + 5;    // es igual a 11, la multiplicación ocurre primero
2 * (3 + 5);  // es igual a 16, por los paréntesis, la suma ocurre primero
```


**La tabulación mejora la lectura del código, pero no posee ningún significado especial**

```javascript
var foo = function() {
  console.log('hola');
};
```



## Operadores



### Operadores Básicos

Los operadores básicos permiten manipular valores.


**Concatenación**

```javascript
var foo = 'hola';
var bar = 'mundo';

console.log(foo + ' ' + bar); // la consola de depuración muestra 'hola mundo'
```


**Multiplicación y división**

```javascript
2 * 3;
2 / 3;
```


**Incrementación y decrementación**

```javascript
var i = 1;

var j = ++i;  // incrementación previa:  j es igual a 2; i es igual a 2
var k = i++;  // incrementación posterior: k es igual a 2; i es igual a 3
```



### Operaciones con Números y Cadenas de Caracteres

En JavaScript, las operaciones con números y cadenas de caracteres (en inglés *strings*) pueden ocasionar resultados no esperados.


**Suma vs. concatenación**

```javascript
var foo = 1;
var bar = '2';

console.log(foo + bar);  // error: La consola de depuración muestra 12
```


**Forzar a una cadena de caracteres actuar como un número**

```javascript
var foo = 1;
var bar = '2';

// el constructor 'Number' obliga a la cadena comportarse como un número
console.log(foo + Number(bar));  // la consola de depuración muestra 3
```

El constructor *Number*, cuando es llamado como una función (como se muestra en el ejemplo) obliga a su argumento a comportarse como un número. También es posible utilizar el operador de *suma unaria*, entregando el mismo resultado:


**Forzar a una cadena de caracteres actuar como un número (utilizando el operador de suma unaria)**

```javascript
console.log(foo + +bar);
```



### Operadores Lógicos

Los operadores lógicos permiten evaluar una serie de operandos utilizando operaciones AND y OR.


**Operadores lógicos AND y OR**

```javascript
var foo = 1;
var bar = 0;
var baz = 2;

foo || bar;   // devuelve 1, el cual es verdadero (true)
bar || foo;   // devuelve 1, el cual es verdadero (true)

foo && bar;   // devuelve 0, el cual es falso (false)
foo && baz;   // devuelve 2, el cual es verdadero (true)
baz && foo;   // devuelve 1, el cual es verdadero (true)
```

El operador `||` (OR lógico) devuelve el valor del primer operando, si éste es verdadero; caso contrario devuelve el segundo operando. Si ambos operandos son falsos devuelve falso (*false*). El operador `&&` (AND lógico) devuelve el valor del primer operando si éste es falso; caso contrario devuelve el segundo operando. Cuando ambos valores son verdaderos devuelve verdadero (*true*), sino devuelve falso.

Puede consultar la sección `Elementos Verdaderos y Falsos` para más detalles sobre que valores se evalúan como `true` y cuales se evalúan como `false`.


> **Nota**
>
> Puede que a veces note que algunos desarrolladores utilizan esta lógica en flujos de control en lugar de utilizar la declaración `if`. Por ejemplo:


```javascript
// realizar algo con foo si foo es verdadero
foo && doSomething(foo);

// establecer bar igual a baz si baz es verdadero;
// caso contrario, establecer a bar igual al
// valor de createBar()
var bar = baz || createBar();
```


Este estilo de declaración es muy elegante y conciso; pero puede ser difícil para leer (sobretodo para principiantes). Por eso se explícita, para reconocerlo cuando este leyendo código. Sin embargo su utilización no es recomendable a menos que esté cómodo con el concepto y su comportamiento.



### Operadores de Comparación

Los operadores de comparación permiten comprobar si determinados valores son equivalentes o idénticos.


**Operadores de Comparación**

```javascript
var foo = 1;
var bar = 0;
var baz = '1';
var bim = 2;

foo == bar;   // devuelve falso (false)
foo != bar;   // devuelve verdadero (true)
foo == baz;   // devuelve verdadero (true); tenga cuidado

foo === baz;             // devuelve falso (false)
foo !== baz;             // devuelve verdadero (true)
foo === parseInt(baz);   // devuelve verdadero (true)

foo > bim;    // devuelve falso (false)
bim > baz;    // devuelve verdadero (true)
foo <= baz;   // devuelve verdadero (true)
```



## Código Condicional

A veces se desea ejecutar un bloque de código bajo ciertas condiciones. Las estructuras de control de flujo — a través de la utilización de las declaraciones `if` y `else` permiten hacerlo.


**Control del flujo**

```javascript
var foo = true;
var bar = false;

if (bar) {
  // este código nunca se ejecutará
  console.log('hola!');
}

if (bar) {
    // este código no se ejecutará
} else {
  if (foo) {
      // este código se ejecutará
  } else {
      // este código se ejecutará si foo y bar son falsos (false)
  }
}
```


> **Nota**
>
> En una línea singular, cuando se escribe una declaración `if`, las llaves no son estrictamente necesarias; sin embargo es recomendable su utilización, ya que hace que el código sea mucho más legible.


Debe tener en cuenta de no definir funciones con el mismo nombre múltiples veces dentro de declaraciones `if`/`else`, ya que puede obtener resultados no esperados.



### Elementos Verdaderos y Falsos

Para controlar el flujo adecuadamente, es importante entender qué tipos de valores son "verdaderos" y cuales "falsos". A veces, algunos valores pueden parecer una cosa pero al final terminan siendo otra.


**Valores que devuelven `verdadero (true)`**

```javascript
'0';
'any string'; // cualquier cadena
[];  // un vector vacío
{};  // un objeto vacío
1;   // cualquier número distinto a cero
```


**Valores que devuelven `falso (false)`**

```javascript
0;
'';  // una cadena vacía
NaN; // la variable JavaScript "not-a-number" (No es un número)
null; // un valor nulo
undefined;  // tenga cuidado -- indefinido (undefined) puede ser redefinido
```



### Variables Condicionales Utilizando el Operador Ternario

A veces se desea establecer el valor de una variable dependiendo de cierta condición. Para hacerlo se puede utilizar una declaración `if`/`else`, sin embargo en muchos casos es más conveniente utilizar el operador ternario. [Definición: El *operador ternario* evalúa una condición; si la condición es verdadera, devuelve cierto valor, caso contrario devuelve un valor diferente.]


**El operador ternario**

```javascript
// establecer a foo igual a 1 si bar es verdadero;
// caso contrario, establecer a foo igual a 0
var foo = bar ? 1 : 0;
```

El operador ternario puede ser utilizado sin devolver un valor a la variable, sin embargo este uso generalmente es desaprobado.



### Declaración Switch

En lugar de utilizar una serie de declaraciones if/else/else if/else, a veces puede ser útil la utilización de la declaración `switch`. [Definición: La declaración `Switch` evalúa el valor de una variable o expresión, y ejecuta diferentes bloques de código dependiendo de ese valor.]


**Una declaración Switch**

```javascript
switch (foo) {

  case 'bar':
      alert('el valor es bar');
  break;

  case 'baz':
      alert('el valor es baz');
  break;

  default:
      alert('de forma predeterminada se ejecutará este código');
  break;

}
```

Las declaraciones `switch` son poco utilizadas en JavaScript, debido a que el mismo comportamiento es posible obtenerlo creando un objeto, el cual posee más potencial ya que es posible reutilizarlo, usarlo para realizar pruebas, etc. Por ejemplo:

```javascript
var stuffToDo = {
  'bar' : function() {
      alert('el valor es bar');
  },

  'baz' : function() {
      alert('el valor es baz');
  },

  'default' : function() {
      alert('de forma predeterminada se ejecutará este código');
  }
};

if (stuffToDo[foo]) {
  stuffToDo[foo]();
} else {
  stuffToDo['default']();
}
```

Más adelante se abarcará el concepto de objetos.



## Bucles

Los bucles (en inglés *loops*) permiten ejecutar un bloque de código un determinado número de veces.


**Bucles**

```javascript
// muestra en la consola 'intento 0', 'intento 1', ..., 'intento 4'
for (var i=0; i<5; i++) {
  console.log('intento ' + i);
}
```

*Note que en el ejemplo se utiliza la palabra var antes de la variable `i`{.varname}, esto hace que dicha variable quede dentro del "alcance" (en inglés *scope*) del bucle. Más adelante en este capítulo se examinará en profundidad el concepto de alcance.*



### Bucles Utilizando For

Un bucle utilizando `for` se compone de cuatro estados y posee la siguiente estructura:

```javascript
for ([expresiónInicial]; [condición]; [incrementoDeLaExpresión])
 [cuerpo]
```

El estado *expresiónInicial* es ejecutado una sola vez, antes que el bucle comience. éste otorga la oportunidad de preparar o declarar variables.

El estado *condición* es ejecutado antes de cada repetición, y retorna un valor que decide si el bucle debe continuar ejecutándose o no. Si el estado condicional evalúa un valor falso el bucle se detiene.

El estado *incrementoDeLaExpresión* es ejecutado al final de cada repetición y otorga la oportunidad de cambiar el estado de importantes variables. Por lo general, este estado implica la incrementación o decrementación de un contador.

El *cuerpo* es el código a ejecutar en cada repetición del bucle.


**Un típico bucle utilizando `for`**

```javascript
for (var i = 0, limit = 100; i < limit; i++) {
  // Este bloque de código será ejecutado 100 veces
  console.log('Actualmente en ' + i);
  // Nota: el último registro que se mostrará
  // en la consola será "Actualmente en 99"
}
```



### Bucles Utilizando While

Un bucle utilizando `while` es similar a una declaración condicional `if`, excepto que el cuerpo va a continuar ejecutándose hasta que la condición a evaluar sea falsa.

```javascript
while ([condición]) [cuerpo]
```


**Un típico bucle utilizando `while`**

```javascript
var i = 0;
while (i < 100) {
  // Este bloque de código se ejecutará 100 veces
  console.log('Actualmente en ' + i);
  i++; // incrementa la variable i
}
```

Puede notar que en el ejemplo se incrementa el contador dentro del cuerpo del bucle, pero también es posible combinar la condición y la incrementación, como se muestra a continuación:


**Bucle utilizando `while` con la combinación de la condición y la incrementación**

```javascript
var i = -1;
while (++i < 100) {
  // Este bloque de código se ejecutará 100 veces
  console.log('Actualmente en ' + i);
}
```

Se comienza en `-1` y luego se utiliza la incrementación previa (`++i`).



### Bucles Utilizando Do-while

Este bucle es exactamente igual que el bucle utilizando `while` excepto que el cuerpo es ejecutado al menos una vez antes que la condición sea evaluada.

```javascript
do [cuerpo] while ([condición])
```


**Un bucle utilizando `do-while`**

```javascript
do {

  // Incluso cuando la condición sea falsa
  // el cuerpo del bucle se ejecutará al menos una vez.

  alert('Hola');

} while (false);
```

Este tipo de bucles son bastantes atípicos ya que en pocas ocasiones se necesita un bucle que se ejecute al menos una vez. De cualquier forma debe estar al tanto de ellos.



### Break y Continue

Usualmente, el fin de la ejecución de un bucle resultará cuando la condición no siga evaluando un valor verdadero, sin embargo también es posible parar un bucle utilizando la declaración `break` dentro del cuerpo.


**Detener un bucle con break**

```javascript
for (var i = 0; i < 10; i++) {
  if (something) {
      break;
  }
}
```

También puede suceder que quiera continuar con el bucle sin tener que ejecutar más sentencias del cuerpo del mismo bucle. Esto puede realizarse utilizando la declaración `continue`.


**Saltar a la siguiente iteración de un bucle**

```javascript
for (var i = 0; i < 10; i++) {

  if (something) {
      continue;
  }

  // La siguiente declaración será ejecutada
  // si la condición 'something' no se cumple
  console.log('Hola');

}
```



## Palabras Reservadas

JavaScript posee un número de "palabras reservadas", o palabras que son especiales dentro del mismo lenguaje. Debe utilizar estas palabras cuando las necesite para su uso específico.

-   `abstract`
-   `boolean`
-   `break`
-   `byte`
-   `case`
-   `catch`
-   `char`
-   `class`
-   `const`
-   `continue`
-   `debugger`
-   `default`
-   `delete`
-   `do`
-   `double`
-   `else`
-   `enum`
-   `export`
-   `extends`
-   `final`
-   `finally`
-   `float`
-   `for`
-   `function`
-   `goto`
-   `if`
-   `implements`
-   `import`
-   `in`
-   `instanceof`
-   `int`
-   `interface`
-   `long`
-   `native`
-   `new`
-   `package`
-   `private`
-   `protected`
-   `public`
-   `return`
-   `short`
-   `static`
-   `super`
-   `switch`
-   `synchronized`
-   `this`
-   `throw`
-   `throws`
-   `transient`
-   `try`
-   `typeof`
-   `var`
-   `void`
-   `volatile`
-   `while`
-   `with`



## Vectores

Los vectores (en español también llamados *matrices* o *arreglos* y en inglés *arrays*) son listas de valores con índice-cero (en inglés *zero-index*), es decir, que el primer elemento del vector está en el índice 0. Éstos son una forma práctica de almacenar un conjunto de datos relacionados (como cadenas de caracteres), aunque en realidad, un vector puede incluir múltiples tipos de datos, incluso otros vectores.


**Un vector simple**

```javascript
var myArray = [ 'hola', 'mundo' ];
```


**Acceder a los ítems del vector a través de su índice**

```javascript
var myArray = [ 'hola', 'mundo', 'foo', 'bar' ];
console.log(myArray[3]);   // muestra en la consola 'bar'
```


**Obtener la cantidad de ítems del vector**

```javascript
var myArray = [ 'hola', 'mundo' ];
console.log(myArray.length);   // muestra en la consola 2
```


**Cambiar el valor de un ítem de un vector**

```javascript
var myArray = [ 'hola', 'mundo' ];
myArray[1] = 'changed';
```

*Como se muestra en el ejemplo "Cambiar el valor de un ítem de un vector" es posible cambiar el valor de un ítem de un vector, sin embargo, por lo general, no es aconsejable.*


**Añadir elementos a un vector**

```javascript
var myArray = [ 'hola', 'mundo' ];
myArray.push('new');
```


**Trabajar con vectores**

```javascript
var myArray = [ 'h', 'o', 'l', 'a' ];
var myString = myArray.join('');   // 'hola'
var mySplit = myString.split('');  // [ 'h', 'o', 'l', 'a' ]
```



## Objetos

Los objetos son elementos que pueden contener cero o más conjuntos de pares de nombres claves y valores asociados a dicho objeto. Los nombres claves pueden ser cualquier palabra o número válido. El valor puede ser cualquier tipo de valor: un número, una cadena, un vector, una función, incluso otro objeto.

[Definición: Cuando uno de los valores de un objeto es una función, ésta es nombrada como un *método* del objeto.] De lo contrario, se los llama *propiedades*.

Curiosamente, en JavaScript, casi todo es un objeto — vectores, funciones, números, incluso cadenas — y todos poseen propiedades y métodos.


**Creación de un "objeto literal"**

```javascript
var myObject = {
  sayHello: function() {
    console.log('hola');
  },

  myName: 'Rebecca'
};

myObject.sayHello();   // se llama al método sayHello,
                       // el cual muestra en la consola 'hola'

console.log(myObject.myName);    // se llama a la propiedad myName,
                                 // la cual muestra en la consola 'Rebecca'
```


> **Nota**
>
> Notar que cuando se crean objetos literales, el nombre de la propiedad puede ser cualquier identificador JavaScript, una cadena de caracteres (encerrada entre comillas) o un número:


```javascript
var myObject = {
    validIdentifier: 123,
    'some string': 456,
    99999: 789
};
```

Los objetos literales pueden ser muy útiles para la organización del código, para más información puede leer el artículo (en inglés) [Using Objects to Organize Your Code](http://blog.rebeccamurphey.com/2009/10/15/using-objects-to-organize-your-code/) por Rebecca Murphey.



## Funciones

Las funciones contienen bloques de código que se ejecutaran repetidamente. A las mismas se le pueden pasar argumentos, y opcionalmente la función puede devolver un valor.

Las funciones pueden ser creadas de varias formas:


**Declaración de una función**

```javascript
function foo() { /* hacer algo */ }
```


**Declaración de una función nombrada**

```javascript
var foo = function() { /* hacer algo */ }
```

*Es preferible el método de función nombrada debido a algunas* *[profundas razones técnicas](http://yura.thinkweb2.com/named-function-expressions/). Igualmente, es probable encontrar a los dos métodos cuando se revise código JavaScript.*



### Utilización de Funciones

**Una función simple**

```javascript
var greet = function(person, greeting) {
  var text = greeting + ', ' + person;
  console.log(text);
};


greet('Rebecca', 'Hola');  // muestra en la consola 'Hola, Rebecca'
```


**Una función que devuelve un valor**

```javascript
var greet = function(person, greeting) {
  var text = greeting + ', ' + person;
  return text;
};

console.log(greet('Rebecca','Hola'));   // la función devuelve 'Hola, Rebecca',
                                         // la cual se muestra en la consola
```


**Una función que devuelve otra función**

```javascript
var greet = function(person, greeting) {
  var text = greeting + ', ' + person;
  return function() { console.log(text); };
};


var greeting = greet('Rebecca', 'Hola');
greeting();  // se muestra en la consola 'Hola, Rebecca'
```



### Funciones Anónimas Autoejecutables

Un patrón común en JavaScript son las funciones anónimas autoejecutables. Este patrón consiste en crear una expresión de función e inmediatamente ejecutarla. El mismo es muy útil para casos en que no se desea intervenir espacios de nombres globales, debido a que ninguna variable declarada dentro de la función es visible desde afuera.


**Función anónima autoejecutable**

```javascript
(function(){
  var foo = 'Hola mundo';
})();


console.log(foo);   // indefinido (undefined)
```



### Funciones como Argumentos

En JavaScript, las funciones son "ciudadanos de primera clase" — pueden ser asignadas a variables o pasadas a otras funciones como argumentos. En jQuery, pasar funciones como argumentos es una práctica muy común.


**Pasar una función anónima como un argumento**

```javascript
var myFn = function(fn) {
  var result = fn();
  console.log(result);
};

myFn(function() { return 'hola mundo'; });   // muestra en la consola 'hola mundo'
```


**Pasar una función nombrada como un argumento**

```javascript
var myFn = function(fn) {
  var result = fn();
  console.log(result);
};

var myOtherFn = function() {
    return 'hola mundo';
};

myFn(myOtherFn);   // muestra en la consola 'hola mundo'
```



## Determinación del Tipo de Variable

JavaScript ofrece una manera de poder comprobar el "tipo" (en inglés *type*) de una variable. Sin embargo, el resultado puede ser confuso — por ejemplo, el tipo de un vector es "object".

Por eso, es una práctica común utilizar el operador `typeof` cuando se trata de determinar el tipo de un valor específico.


**Determinar el tipo en diferentes variables**

```javascript
var myFunction = function() {
  console.log('hola');
};

var myObject = {
    foo : 'bar'
};

var myArray = [ 'a', 'b', 'c' ];

var myString = 'hola';

var myNumber = 3;

typeof myFunction;   // devuelve 'function'
typeof myObject;     // devuelve 'object'
typeof myArray;      // devuelve 'object' -- tenga cuidado
typeof myString;     // devuelve 'string'
typeof myNumber;     // devuelve 'number'

typeof null;         // devuelve 'object' -- tenga cuidado


if (myArray.push && myArray.slice && myArray.join) {
    // probablemente sea un vector
    // (este estilo es llamado, en inglés, "duck typing")
}

if (Object.prototype.toString.call(myArray) === '[object Array]') {
    // definitivamente es un vector;
    // esta es considerada la forma más robusta
    // de determinar si un valor es un vector.
}
```

jQuery ofrece métodos para ayudar a determinar el tipo de un determinado valor. Estos métodos serán vistos más adelante.



## La palabra clave `this`

En JavaScript, así como en la mayoría de los lenguajes de programación orientados a objetos, `this` es una palabra clave especial que hace referencia al objeto en donde el método está siendo invocado. El valor de `this` es determinado utilizando una serie de simples pasos:

1.  Si la función es invocada utilizando [Function.call](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Function/call) o [Function.apply](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Function/apply), `this` tendrá el valor del primer argumento pasado al método. Si el argumento es nulo (*null*) o indefinido (*undefined*), `this` hará     referencia el objeto global (el objeto `window`);
2.  Si la función a invocar es creada utilizando [Function.bind](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Function/bind), `this` será el primer argumento que es pasado a la función en el momento en que se la crea;
3.  Si la función es invocada como un método de un objeto, `this` referenciará a dicho objeto;
4.  De lo contrario, si la función es invocada como una función independiente, no unida a algún objeto, `this` referenciará al objeto global.


**Una función invocada utilizando Function.call**

```javascript
var myObject = {
  sayHello : function() {
      console.log('Hola, mi nombre es ' + this.myName);
  },

  myName : 'Rebecca'
};

var secondObject = {
  myName : 'Colin'
};

myObject.sayHello();                  // registra 'Hola, mi nombre es Rebecca'
myObject.sayHello.call(secondObject); // registra 'Hola, mi nombre es Colin'
```


**Una función creada utilizando Function.bind**

```javascript
var myName = 'el objeto global',

  sayHello = function () {
      console.log('Hola, mi nombre es ' + this.myName);
  },

  myObject = {
      myName : 'Rebecca'
  };

var myObjectHello = sayHello.bind(myObject);

sayHello();       // registra 'Hola, mi nombre es el objeto global'
myObjectHello();  // registra 'Hola, mi nombre es Rebecca'
```


**Una función vinculada a un objeto**

```javascript
var myName = 'el objeto global',

  sayHello = function() {
      console.log('Hola, mi nombre es ' + this.myName);
  },

  myObject = {
      myName : 'Rebecca'
  },

  secondObject = {
      myName : 'Colin'
  };

myObject.sayHello = sayHello;
secondObject.sayHello = sayHello;

sayHello();               // registra 'Hola, mi nombre es el objeto global'
myObject.sayHello();      // registra 'Hola, mi nombre es Rebecca'
secondObject.sayHello();  // registra 'Hola, mi nombre es Colin'
```


> **Nota**
>
> En algunas oportunidades, cuando se invoca una función que se encuentra dentro de un espacio de nombres (en inglés *namespace*) amplio, puede ser una tentación guardar la referencia a la función actual en una variable más corta y accesible. Sin embargo, es importante no realizarlo en instancias de métodos, ya que puede llevar a la ejecución de código incorrecto. Por ejemplo:


```javascript
var myNamespace = {
  myObject: {
    sayHello: function() {
      console.log('Hola, mi nombre es ' + this.myName);
    },

    myName: 'Rebecca'
  }
};

var hello = myNamespace.myObject.sayHello;

hello();  // registra 'Hola, mi nombre es undefined'
```

Para que no ocurran estos errores, es necesario hacer referencia al objeto en donde el método es invocado:

```javascript
var myNamespace = {
  myObject : {
    sayHello : function() {
        console.log('Hola, mi nombre es ' + this.myName);
    },

    myName : 'Rebecca'
  }
};

var obj = myNamespace.myObject;

obj.sayHello();  // registra 'Hola, mi nombre es Rebecca'
```



## Alcance

El "alcance" (en inglés *scope*) se refiere a las variables que están disponibles en un bloque de código en un tiempo determinado. La falta de comprensión de este concepto puede llevar a una frustrante experiencia de depuración.

Cuando una variable es declarada dentro de una función utilizando la palabra clave `var`, ésta únicamente esta disponible para el código dentro de la función — todo el código fuera de dicha función no puede acceder a la variable. Por otro lado, las funciones definidas *dentro* de la función *podrán* acceder a la variable declarada.

Las variables que son declaradas dentro de la función sin la palabra clave `var` no quedan dentro del ámbito de la misma función — JavaScript buscará el lugar en donde la variable fue previamente declarada, y en caso de no haber sido declarada, es definida dentro del alcance global, lo cual puede ocasionar consecuencias inesperadas;


**Funciones tienen acceso a variables definidas dentro del mismo alcance**

```javascript
var foo = 'hola';

var sayHello = function() {
  console.log(foo);
};

sayHello();         // muestra en la consola 'hola'
console.log(foo);   // también muestra en la consola 'hola'
```


**El código de afuera no tiene acceso a la variable definida dentro de la función**

```javascript
var sayHello = function() {
  var foo = 'hola';
  console.log(foo);
};

sayHello();         // muestra en la consola 'hola'
console.log(foo);   // no muestra nada en la consola
```


**Variables con nombres iguales pero valores diferentes pueden existir en diferentes alcances**

```javascript
var foo = 'mundo';

var sayHello = function() {
  var foo = 'hola';
  console.log(foo);
};

sayHello();         // muestra en la consola 'hola'
console.log(foo);   // muestra en la consola 'mundo'
```


**Las funciones pueden "ver" los cambios en las variables antes de que la función sea definida**

```javascript
var myFunction = function() {
  var foo = 'hola';

  var myFn = function() {
      console.log(foo);
  };

  foo = 'mundo';

  return myFn;
};

var f = myFunction();
f();  // registra 'mundo' -- error
```


**Alcance**

```javascript
// una función anónima autoejecutable
(function() {
  var baz = 1;
  var bim = function() { alert(baz); };
  bar = function() { alert(baz); };
})();

console.log(baz);  // La consola no muestra nada, ya que baz
                   // esta definida dentro del alcance de la función anónima

bar();  // bar esta definido fuera de la función anónima
        // ya que fue declarada sin la palabra clave var; además,
        // como fue definida dentro del mismo alcance que baz,
        // se puede consultar el valor de baz a pesar que
        // ésta este definida dentro del alcance de la función anónima

bim();  // bim no esta definida para ser accesible fuera de la función anónima,
        // por lo cual se mostrará un error
```



## Clausuras

Las clausuras (en inglés *closures*) son una extensión del concepto de alcance (*scope*) — funciones que tienen acceso a las variables que están disponibles dentro del ámbito en donde se creó la función. Si este concepto es confuso, no debe preocuparse: se entiende mejor a través de ejemplos.

En el ejemplo 2.47 se muestra la forma en que funciones tienen acceso para cambiar el valor de las variables. El mismo comportamiento sucede en funciones creadas dentro de bucles — la función "observa" el cambio en la variable, incluso después de que la función sea definida, resultando que en todos los clicks aparezca una ventana de alerta mostrando el valor 5.


**¿Cómo establecer el valor de `i`?**

```javascript
/* esto no se comporta como se desea; */
/* cada click mostrará una ventana de alerta con el valor 5 */
for (var i=0; i<5; i++) {
  $('<p>hacer click</p>').appendTo('body').click(function() {
      alert(i);
  });
}
```


**Establecer el valor de `i` utilizando una clausura**

```javascript
/* solución: “clausurar” el valor de i dentro de createFunction */
var createFunction = function(i) {
  return function() {
    alert(i);
  };
};

for (var i = 0; i < 5; i++) {
  $('<p>hacer click</p>').appendTo('body').click(createFunction(i));
}
```

Las clausuras también pueden ser utilizadas para resolver problemas con la palabra clave `this`, la cual es única en cada alcance.


**Utilizar una clausura para acceder simultáneamente a instancias de objetos internos y externos.**

```javascript
var outerObj = {
  myName: 'externo',
  outerFunction: function() {

    // provee una referencia al mismo objeto outerObj
    // para utilizar dentro de innerFunction
    var self = this;

    var innerObj = {
      myName: 'interno',
      innerFunction: function() {
        console.log(self.myName, this.myName); // registra 'externo interno'
      }
    };

    innerObj.innerFunction();

    console.log(this.myName); // registra 'externo'
  }
};

outerObj.outerFunction();
```

Este mecanismo puede ser útil cuando trabaje con funciones de devolución de llamadas (en inglés *callbacks*). Sin embargo, en estos casos, es preferible que utilice [Function.bind](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Function/bind) ya que evitará cualquier sobrecarga asociada con el alcance (*scope*).


