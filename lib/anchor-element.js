// Generated by CoffeeScript 1.10.0
(function() {
  var BTKAnchorElement, ViewComponent, addClasses,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  ViewComponent = require('./view-component');

  addClasses = require('./util').addClasses;

  BTKAnchorElement = (function(superClass) {
    extend(BTKAnchorElement, superClass);

    function BTKAnchorElement() {
      return BTKAnchorElement.__super__.constructor.apply(this, arguments);
    }

    BTKAnchorElement.prototype.setModel = function(model) {
      this.model = model;
      if (this.model.options) {
        this.setAttribute('href', this.model.options.href || '#');
        addClasses(this, this.model.options["class"]);
      }
      this.innerHTML = this.model.getString();
      this.model.manageComponentViews(this);
      return this;
    };

    return BTKAnchorElement;

  })(HTMLAnchorElement);

  module.exports = document.registerElement('btk-a', {
    "extends": 'a',
    prototype: BTKAnchorElement.prototype
  });

}).call(this);