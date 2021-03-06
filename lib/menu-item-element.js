// Generated by CoffeeScript 1.10.0
(function() {
  var BTKMenuItemElement, addClasses,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  addClasses = require('./util').addClasses;

  BTKMenuItemElement = (function(superClass) {
    extend(BTKMenuItemElement, superClass);

    function BTKMenuItemElement() {
      return BTKMenuItemElement.__super__.constructor.apply(this, arguments);
    }

    BTKMenuItemElement.prototype.setModel = function(model) {
      var anchor;
      this.model = model;
      addClasses(this, this.model.options["class"]);
      this.innerHTML = this.model.getString();
      if (this.model.action) {
        if (anchor = this.querySelector('a')) {
          anchor.addEventListener('click', (function(_this) {
            return function() {
              return _this.model.trigger();
            };
          })(this));
        }
      }
      return this;
    };

    return BTKMenuItemElement;

  })(HTMLLIElement);

  module.exports = document.registerElement('btk-menu-item', {
    "extends": 'li',
    prototype: BTKMenuItemElement.prototype
  });

}).call(this);
