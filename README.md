# Bootstrap Kit

Bootstrap Kit is a toolkit for creating Web Applications.  It tries to lean
to atom API.  Bootstrap Kit aims to provide views for web components.

## Documentation

You can create API documentation with endokken:

   npm install -g endokken

Generate documentation:

   endokken

View documentation:

   firefox docs/README

## Glossary

xComponent:
  If you find a class names xComponent, it is a class, which contains a
  DOM node and manages the content of the DOM node, but is not an HTMLElement
  itself.

xElement:
  Classes named xElement provide HTML-Elements, which can be assigned as
  views to models
