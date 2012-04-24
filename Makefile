DATE = 'Abril 2012'
EPUB_TITLE = 'Fundamentos de jQuery'
HTML_TITLE = 'Libro gratuito de jQuery en espa&ntilde;ol - Fundamentos de jQuery'

all:

	@@echo "Copiando figuras en la carpeta html"
	@@cp -a ./libro/markdown/figuras ./libro/html
	@@echo "Generando HTML"
	@@pandoc -s -S -N --toc --section-divs --highlight-style=tango --template ./pandoc/html.template -T ${HTML_TITLE} --variable=date:${DATE} ./libro/markdown/cap01-bienvenido.markdown ./libro/markdown/cap02-conceptos-basicos-javascript.markdown ./libro/markdown/cap03-conceptos-basicos-jquery.markdown ./libro/markdown/cap04-nucleo-jquery.markdown ./libro/markdown/cap05-eventos.markdown ./libro/markdown/cap06-efectos.markdown ./libro/markdown/cap07-ajax.markdown ./libro/markdown/cap08-extensiones.markdown ./libro/markdown/cap09-mejoras-rendimiento.markdown ./libro/markdown/cap10-organizacion-codigo.markdown ./libro/markdown/cap11-eventos-personalizados.markdown ./libro/markdown/licencia.markdown -o ./libro/html/index.html
	@@echo "HTML generado"

	@@echo "Generando EPUB"
	@@pandoc -S --epub-metadata=./pandoc/epub.metadata.xml --epub-stylesheet=./pandoc/epub.styles.css --variable=title:${EPUB_TITLE} ./libro/markdown/cap01-bienvenido.markdown ./libro/markdown/cap02-conceptos-basicos-javascript.markdown ./libro/markdown/cap03-conceptos-basicos-jquery.markdown ./libro/markdown/cap04-nucleo-jquery.markdown ./libro/markdown/cap05-eventos.markdown ./libro/markdown/cap06-efectos.markdown ./libro/markdown/cap07-ajax.markdown ./libro/markdown/cap08-extensiones.markdown ./libro/markdown/cap09-mejoras-rendimiento.markdown ./libro/markdown/cap10-organizacion-codigo.markdown ./libro/markdown/cap11-eventos-personalizados.markdown ./libro/markdown/licencia.markdown -o ./libro/epub/Fundamentos_de_jQuery.epub
	@@echo "EPUB generado"

	@@echo "Copiando figuras para generar PDF"
	@@cp -a ./libro/markdown/figuras ./
	@@echo "Generando PDF"
	@@pandoc -N --toc --latex-engine=xelatex --no-highlight --template ./pandoc/latex.template --variable=date:${DATE} ./libro/markdown/cap01-bienvenido.markdown ./libro/markdown/cap02-conceptos-basicos-javascript.markdown ./libro/markdown/cap03-conceptos-basicos-jquery.markdown ./libro/markdown/cap04-nucleo-jquery.markdown ./libro/markdown/cap05-eventos.markdown ./libro/markdown/cap06-efectos.markdown ./libro/markdown/cap07-ajax.markdown ./libro/markdown/cap08-extensiones.markdown ./libro/markdown/cap09-mejoras-rendimiento.markdown ./libro/markdown/cap10-organizacion-codigo.markdown ./libro/markdown/cap11-eventos-personalizados.markdown -o ./libro/pdf/Fundamentos_de_jQuery.pdf
	@@echo "PDF generado"
	@@echo "Eliminando figuras"
	@@rm -r ./figuras
	@@echo "Archivos generados correctamente"