DATE = 'Septiembre 2011'
EPUB_TITLE = 'Fundamentos de jQuery'
HTML_TITLE = 'Libro gratuito de jQuery en espa&ntilde;ol'

all:
	
	@@echo "Generando HTML"
	@@pandoc -s -S -N --toc --section-divs --template ./pandoc/html.template -T ${HTML_TITLE} --variable=date:${DATE} ./libro/markdown/cap01-bienvenido.markdown ./libro/markdown/cap02-conceptos-basicos-javascript.markdown ./libro/markdown/cap03-conceptos-basicos-jquery.markdown ./libro/markdown/cap04-nucleo-jquery.markdown ./libro/markdown/cap05-eventos.markdown ./libro/markdown/cap06-efectos.markdown ./libro/markdown/cap07-ajax.markdown ./libro/markdown/cap08-extensiones.markdown ./libro/markdown/cap09-mejoras-rendimiento.markdown ./libro/markdown/cap10-organizacion-codigo.markdown ./libro/markdown/cap11-eventos-personalizados.markdown ./libro/markdown/licencia.markdown -o ./libro/html/index.html
	@@echo "HTML generado"
	
	@@echo "Generando EPUB"
	@@pandoc -S --epub-metadata=./pandoc/epub.metadata.xml --epub-stylesheet=./pandoc/epub.styles.css --variable=title:${EPUB_TITLE} ./libro/markdown/cap01-bienvenido.markdown ./libro/markdown/cap02-conceptos-basicos-javascript.markdown ./libro/markdown/cap03-conceptos-basicos-jquery.markdown ./libro/markdown/cap04-nucleo-jquery.markdown ./libro/markdown/cap05-eventos.markdown ./libro/markdown/cap06-efectos.markdown ./libro/markdown/cap07-ajax.markdown ./libro/markdown/cap08-extensiones.markdown ./libro/markdown/cap09-mejoras-rendimiento.markdown ./libro/markdown/cap10-organizacion-codigo.markdown ./libro/markdown/cap11-eventos-personalizados.markdown ./libro/markdown/licencia.markdown -o ./libro/epub/Fundamentos_de_jQuery.epub
	@@echo "EPUB generado"
	
	@@cd libro/html/; echo "Entrando en libro/html/ para generar PDF"; \
	markdown2pdf -N --toc --xetex --template ../../pandoc/latex.template --variable=date:${DATE} ../markdown/cap01-bienvenido.markdown ../markdown/cap02-conceptos-basicos-javascript.markdown ../markdown/cap03-conceptos-basicos-jquery.markdown ../markdown/cap04-nucleo-jquery.markdown ../markdown/cap05-eventos.markdown ../markdown/cap06-efectos.markdown ../markdown/cap07-ajax.markdown ../markdown/cap08-extensiones.markdown ../markdown/cap09-mejoras-rendimiento.markdown ../markdown/cap10-organizacion-codigo.markdown ../markdown/cap11-eventos-personalizados.markdown -o ../pdf/Fundamentos_de_jQuery.pdf
	@@echo "PDF generado"