// Generated by CoffeeScript 1.10.0
(function() {
  var CompositeDisposable, Emitter, ViewRegistry, WebComponent, initViews, ref, str2elem, views,
    slice = [].slice;

  ref = require('./event-kit'), Emitter = ref.Emitter, CompositeDisposable = ref.CompositeDisposable;

  ViewRegistry = require('./view-registry');

  str2elem = require('./util').str2elem;

  views = null;

  initViews = function(object) {
    object.views = views = new ViewRegistry();
    return views.addViewProvider(WebComponent, function(object) {
      var e;
      e = str2elem(object.getString() || '<div></div>');
      if (object.action) {
        e.addEventListener('click', function() {
          return object.trigger();
        });
      }
      object.manageComponentViews(e);
      return e;
    });
  };

  WebComponent = (function() {
    function WebComponent() {
      var action, args;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      if (!(this instanceof WebComponent)) {
        return (function(func, args, ctor) {
          ctor.prototype = func.prototype;
          var child = new ctor, result = func.apply(child, args);
          return Object(result) === result ? result : child;
        })(WebComponent, args, function(){});
      }
      if (this.options == null) {
        this.options = {};
      }
      this.string = null;
      this.components = [];
      if (this.emitter == null) {
        this.emitter = new Emitter();
      }
      this.container = null;
      this.subscription = new CompositeDisposable();
      this.data = null;
      if (args.length > 0) {
        if (typeof args[0] === 'string') {
          this.string = args[0];
          args = args.slice(1);
        }
      }
      if (args.length > 0) {
        if (!((args[0] instanceof WebComponent) || (args[0] instanceof Array) || (args[0] instanceof Function))) {
          this.options = args[0];
          args = args.slice(1);
        }
      }
      if (args.length > 0) {
        action = args[args.length - 1];
        if (action instanceof Function) {
          this.action = action;
          this.onDidTrigger(action);
          args = args.slice(0, -1);
        }
      }
      if (this.options.data) {
        this.setData(this.options.data);
        delete this.options.data;
      }
      this.addComponents.apply(this, args);
    }


    /*
    Section: View Management
    
    WebComponent manages a singleton{ViewRegistry} instance view class methods.
     */

    WebComponent.getView = function(component) {
      return views.getView(component);
    };

    WebComponent.hasView = function(component) {
      return views.hasView(component);
    };

    WebComponent.addViewProvider = function(modelClass, callback) {
      return views.addViewProvider(modelClass, callback);
    };

    WebComponent.getViewProvider = function(modelClass) {
      return views.getViewProvider(modelClass);
    };

    WebComponent.clearViewRegistry = function() {
      return initViews(WebComponent);
    };


    /*
    Section: String API
     */

    WebComponent.prototype.getString = function() {
      return this.string || '';
    };


    /*
    Section: Data API
     */

    WebComponent.prototype.updateData = function(object) {
      var changes, name, newValue, oldValue;
      changes = {};
      if (object instanceof Array) {
        oldValue = this.data;
        newValue = object;
        changes = {
          oldValue: oldValue,
          newValue: newValue
        };
        this.data = newValue;
      } else {
        if (this.data == null) {
          this.data = {};
        }
        for (name in object) {
          newValue = object[name];
          if ((oldValue = this.data[name] || null) !== newValue) {
            changes[name] = {
              oldValue: oldValue,
              newValue: newValue
            };
            this.data[name] = newValue;
          }
        }
      }
      if (JSON.stringify(changes) !== '{}') {
        return this.emitter.emit('did-update-data', {
          changes: changes,
          data: this.data
        });
      }
    };

    WebComponent.prototype.clearData = function() {
      this.data = null;
      return this.emitter.emit('did-clear-data');
    };

    WebComponent.prototype.setData = function() {
      var args, obj;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      if (args.length === 2) {
        obj = {};
        obj[args[0]] = args[1];
        return this.updateData(obj);
      } else {
        this.clearData();
        this.updateData(object);
        this.emitter.emit('did-set-data', this.data);
        return this.data;
      }
    };

    WebComponent.prototype.getData = function(name) {
      if (name != null) {
        return this.data[name];
      } else {
        return this.data;
      }
    };

    WebComponent.prototype.onDidUpdateData = function(callback) {
      return this.emitter.on('did-update-data', callback);
    };

    WebComponent.prototype.onDidSetData = function(callback) {
      return this.emitter.on('did-set-data', callback);
    };

    WebComponent.prototype.onDidClearData = function(callback) {
      return this.emitter.on('did-clear-data', callback);
    };


    /*
    Section: View API
     */

    WebComponent.prototype.setView = function(view) {
      if (views.hasView(this)) {
        views.replaceView(this, view);
        return this.options.view = view;
      } else {
        this.options.view = view;
        return views.getView(this);
      }
    };

    WebComponent.prototype.getView = function(selector) {
      if (selector) {
        return WebComponent.getView(this).querySelector(selector);
      } else {
        return WebComponent.getView(this);
      }
    };


    /*
    Section: Managing Components
     */

    WebComponent.prototype.addComponent = function() {
      var action, args, autoAttachComponents, component, ref1;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      component = args[0];
      action = null;
      if (typeof component === 'string') {
        component = (function(func, args, ctor) {
          ctor.prototype = func.prototype;
          var child = new ctor, result = func.apply(child, args);
          return Object(result) === result ? result : child;
        })(WebComponent, args, function(){});
      } else {
        if (args.length > 1) {
          action = args[1];
        }
      }
      this.components.push(component);
      component.container = this;
      if (action) {
        component.onDidTrigger(action);
      }
      autoAttachComponents = (ref1 = this.options.autoAttachComponents) != null ? ref1 : true;
      if (autoAttachComponents && WebComponent.hasView(this)) {
        this.attachComponentView(WebComponent.getView(this), component);
      }
      this.emitter.emit('did-add-component', {
        parent: this,
        component: component
      });
      component.emitter.emit('did-add-this-component', {
        parent: this,
        component: component
      });
      return component;
    };

    WebComponent.prototype.getComponent = function(index) {
      if (index == null) {
        index = 0;
      }
      return this.components[index];
    };

    WebComponent.prototype.getComponents = function() {
      return this.components;
    };

    WebComponent.prototype.getNextComponent = function(component) {
      var next;
      next = this.components.indexOf(component) + 1;
      if (next >= this.components.length) {
        return null;
      } else {
        return this.components[next];
      }
    };

    WebComponent.prototype.getPrevComponent = function(component) {
      var prev;
      prev = this.components.indexOf(component) - 1;
      if (index < 0) {
        return null;
      } else {
        return this.components[index];
      }
    };

    WebComponent.prototype.isContainedIn = function(type) {
      var component;
      component = this;
      while (component.container != null) {
        if (component.container instanceof type) {
          return true;
        }
        component = component.container;
      }
      return false;
    };

    WebComponent.prototype.updateComponentsKeyedList = function() {
      var arg, args, component, i, item, j, key, len, len1, results, visited;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      visited = [];
      key = this.options.key;
      if (this.keyed == null) {
        this.keyed = {};
      }
      results = [];
      for (i = 0, len = args.length; i < len; i++) {
        arg = args[i];
        this.keyed;
        for (j = 0, len1 = data.length; j < len1; j++) {
          item = data[j];
          if (!(item.name in this.hosts)) {
            this.addComponent(new VMHost());
          }
          this.hosts[item.name].update(item);
          visited.push(this.hosts[item.name]);
        }
        results.push((function() {
          var k, len2, ref1, results1;
          ref1 = this.getComponents();
          results1 = [];
          for (k = 0, len2 = ref1.length; k < len2; k++) {
            component = ref1[k];
            if (visited.indexOf(component) < 0) {
              results1.push(this.removeComponent(component));
            } else {
              results1.push(void 0);
            }
          }
          return results1;
        }).call(this));
      }
      return results;
    };

    WebComponent.prototype.addComponents = function() {
      var arg, args, component, i, len, results;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      results = [];
      for (i = 0, len = args.length; i < len; i++) {
        arg = args[i];
        if (!arg) {
          continue;
        }
        if (arg instanceof Array) {
          results.push((function() {
            var j, len1, results1;
            results1 = [];
            for (j = 0, len1 = arg.length; j < len1; j++) {
              component = arg[j];
              results1.push(this.addComponent(component));
            }
            return results1;
          }).call(this));
        } else {
          results.push(this.addComponent(arg));
        }
      }
      return results;
    };

    WebComponent.prototype.removeComponent = function(component) {
      component.container = null;
      this.components.remove(component);
      return this.emitter.emit('did-remove-component', {
        parent: this,
        component: component
      });
    };

    WebComponent.prototype.removeComponents = function() {
      var component, i, len, ref1, results;
      ref1 = this.getComponents();
      results = [];
      for (i = 0, len = ref1.length; i < len; i++) {
        component = ref1[i];
        results.push(this.removeComponent(component));
      }
      return results;
    };

    WebComponent.prototype.onDidTrigger = function(callback) {
      console.log('onDidTrigger', callback);
      return this.emitter.on('did-trigger', callback);
    };

    WebComponent.prototype.trigger = function() {
      console.log('trigger', this);
      return this.emitter.emit('did-trigger', this);
    };

    WebComponent.prototype.onDidAddThisComponent = function(callback) {
      return this.emitter.on('did-add-this-component', callback);
    };

    WebComponent.prototype.onDidAddComponent = function(callback) {
      return this.emitter.on('did-add-component', callback);
    };

    WebComponent.prototype.onDidRemoveComponent = function(callback) {
      return this.emitter.on('did-remove-component', callback);
    };

    WebComponent.prototype.observeComponents = function(callback) {
      var component, i, len, ref1;
      ref1 = this.getComponents();
      for (i = 0, len = ref1.length; i < len; i++) {
        component = ref1[i];
        callback(component);
      }
      return this.emitter.on('did-add-component', function(arg1) {
        var component;
        component = arg1.component;
        return callback(component);
      });
    };

    WebComponent.prototype.manageComponentViews = function(element) {
      return this.observeComponents((function(_this) {
        return function(component) {
          return _this.attachComponentView(element, component);
        };
      })(this));
    };

    WebComponent.prototype.attachComponentView = function(element, component) {
      element.appendChild(WebComponent.getView(component));
      return component.onDidRemoveComponent(function(arg1) {
        var component, e, error;
        component = arg1.component;
        try {
          return element.removeChild(WebComponent.getView(component));
        } catch (error) {
          e = error;
          return null;
        }
      });
    };

    return WebComponent;

  })();

  initViews(WebComponent);

  module.exports = WebComponent;

}).call(this);