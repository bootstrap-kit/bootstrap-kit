// Generated by CoffeeScript 1.10.0
(function() {
  var BTKGlyphElement, addClasses,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  addClasses = require('./util').addClasses;

  BTKGlyphElement = (function(superClass) {
    extend(BTKGlyphElement, superClass);

    function BTKGlyphElement() {
      return BTKGlyphElement.__super__.constructor.apply(this, arguments);
    }

    BTKGlyphElement.prototype.setModel = function(model) {
      var cl, m;
      this.model = model;
      if (cl = this.model.getString()) {
        if (m = cl.match(/^(\w+)-/)) {
          this.domNode.classList.add(m[1]);
        }
        this.addClasses(cl);
      }
      addClasses(this, this.model.options["class"]);
      return this;
    };

    return BTKGlyphElement;

  })(HTMLSpanElement);

  module.exports = document.registerElement('btk-glyph', {
    "extends": 'i',
    prototype: BTKGlyphElement.prototype
  });

}).call(this);
