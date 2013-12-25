/*
Classy JSON v 1.0
copyright 2006 Thomas Frank

This program is free software under the terms of the 
GNU General Public License version 2 as published by the Free 
Software Foundation. It is distributed without any warranty.
 */

classyJSON = {
	defaultMaxDepth : 100,
	stringify : function(obj, maxDepth, co) {
		if (!co) {
			co = 0
		}
		;
		if (maxDepth / 1 != maxDepth) {
			maxDepth = this.defaultMaxDepth
		}
		;
		var isArray = !!obj.sort;
		var objstr = isArray ? "[" : "{";
		for ( var i in obj) {
			if (Object.prototype[i] || i == "deepcopy") {
				continue
			}
			;
			if (objstr.length > 1) {
				objstr += ","
			}
			;
			if (!isArray) {
				objstr += "\"" + i + "\":"
			}
			;
			var val = obj[i];
			if (typeof val == "object" && co < maxDepth) {
				objstr += this.stringify(val, co + 1)
			} else {
				if (typeof val == "string") {
					val = '"'
							+ val.replace(/\\/g, "\\\\").replace(/"/g, '\\"')
									.replace(/\n/g, "\\n")
									.replace(/\r/g, "\\r")
									.replace(/\t/g, "\\t") + '"'
				}
				;
				objstr += val
			}
		}
		;
		objstr += isArray ? "]" : "}";
		return objstr.replace(/\n/g, "").replace(/\r/g, "")
	},
	objJoin : function() {
		this.reprivate = "";
		var a = arguments;
		var x = "";
		for ( var i = 0; i < a.length; i++) {
			a[i].deepCopy("republic");
			var y = this.stringify(a[i]);
			if (y[i] == "{}") {
				continue
			}
			;
			y = y.substring(0, y.length - 1);
			if (i > 0) {
				;
				y = "," + y.substring(1)
			}
			;
			x += y
		}
		;
		x = x.split("{,").join("{");
		eval("var obj=" + x + "}");
		var x = this.reprivate;
		x = x.substring(0, x.length - 1);
		var f = obj.classify().privateMembers(x);
		var obj = new f();
		return obj
	},
	deepCopy : function(obj, maxDepth) {
		this.reprivate = "";
		var repr = obj.deepCopy("republic");
		eval("var obj=" + this.stringify(obj, maxDepth));
		if (repr) {
			var x = this.reprivate;
			x = x.substring(0, x.length - 1);
			var f = obj.classify().privateMembers(x);
			var obj = new f()
		}
		;
		return obj
	},
	constructThings : function() {
		var x = classyJSON_privates.split(",");
		var classyJSON_privates = {};
		for ( var i = 0; i < x.length; i++) {
			if (!Object.prototype[x[i]] && x[i]) {
				classyJSON_privates[x[i]] = 1
			}
		}
		;
		for ( var i in classyJSON_obj) {
			if (classyJSON_privates[i] != 1) {
				this[i] = classyJSON_obj[i]
			}
		}
		;
		for ( var i in this) {
			if (Object.prototype[i] || typeof this[i] != "function") {
				continue
			}
			;
			var x = this[i] + "";
			var orgx = x;
			for ( var j in classyJSON_privates) {
				if (classyJSON_privates[j] != 1) {
					continue
				}
				;
				x = x.replace(new RegExp("this." + j + "([^\\w])", "g"),
						"classyJSON_obj." + j + "$1")
			}
			;
			if (orgx != x) {
				eval("this[i]=" + x)
			}
		}
	},
	classify : function(obj, maxDepth) {
		var x = this.stringify(obj, maxDepth);
		var x = 'function(){' + 'var classyJSON_obj=' + x
				+ ';var classyJSON_privates="";'
				+ 'eval(classyJSON.construct);'
				+ 'eval("this.deepCopy="+classyJSON.deepcopyspecial)}';
		eval("x=" + x);
		return x
	},
	inherit : function() {
		var orgC = this.construct;
		this.tempPrivates = "";
		this.construct = 'classyJSON.tempPrivates+=classyJSON_privates+",";'
				+ 'for(var i in classyJSON_obj){this[i]=classyJSON_obj[i]}';
		var a = arguments;
		var o = [];
		var x = "var classyJSON_obj=this.objJoin(";
		for ( var i = 0; i < a.length; i++) {
			if (typeof a[i] == "function") {
				o.push(new a[i]())
			} else {
				o.push(a[i])
			}
			;
			if (i > 0) {
				x += ","
			}
			;
			x += 'o[' + i + ']'
		}
		;
		eval(x + ")");
		this.construct = orgC;
		var y = this.tempPrivates;
		while (y.indexOf(",,") >= 0) {
			y = y.split(",,").join(",")
		}
		;
		y = y.substring(0, y.length - 1);
		var o = this.classify(classyJSON_obj);
		o = this.privateMembers(o, y);
		return o
	},
	privateMembers : function(constr, privates, s) {
		if (!privates) {
			privates = ""
		}
		;
		if (s) {
			var p = "," + privates + ",";
			var p2 = "";
			var tempobj = new constr();
			tempobj.deepCopy("republic");
			for ( var i in tempobj) {
				if (!Object.prototype[i]) {
					x += i + ",";
					var t = typeof tempobj[i];
					if (tempobj[i].sort) {
						t = "array"
					}
					;
					if (s == "not" && p.indexOf("," + i + ",") < 0) {
						p2 += i + ","
					}
					;
					if (s == "type" && p.indexOf("," + t + ",") >= 0) {
						p2 += i + ","
					}
					;
					if (s == "notType" && p.indexOf("," + t + ",") < 0) {
						p2 += i + ","
					}
				}
			}
			;
			privates = p2.substring(0, p2.length - 1)
		}
		;
		var x = constr + "";
		x = x.replace(/classyJSON_privates[^=]*=[^"]*"[^"]*/g,
				'classyJSON_privates="' + privates);
		eval("x=" + x);
		return x
	},
	extendPrototypes : function() {
		var st = (this.constructThings + "").indexOf("{") + 1;
		var en = (this.constructThings + "").lastIndexOf("}");
		this.construct = (this.constructThings + "").substring(st, en);/*
																		 * Object.prototype.stringify=function(){return
																		 * classyJSON.stringify(this)}
																		 */
		;
		var x = function(maxDepth) {
			if (maxDepth == "republicfunc") {
				var x = classyJSON_privates;
				var y = classyJSON_obj;
				for ( var i in x) {
					if (!Object.prototype[i]) {
						classyJSON.reprivate += i + ",";
						if (y[i] && !this[i]) {
							this[i] = y[i]
						}
					}
				}
				;
				for ( var i in this) {
					if (!Object.prototype[i] && typeof this[i] == "function") {
						var x = this[i] + "";
						x = x.replace(/classyJSON_obj\./g, "this.");
						eval('this.' + i + '=' + x)
					}
				}
				;
				return true
			}
			;
			if (maxDepth == "republic") {
				return false
			}
			;
			return classyJSON.deepCopy(this, maxDepth)
		};
		Object.prototype.deepCopy = x;
		this.deepcopyspecial = (x + "").replace(/republicfunc/g, "republic");
		Object.prototype.classify = function(maxDepth) {
			return classyJSON.classify(this, maxDepth)
		};
		var x = function() {
			var a = arguments;
			var x = "classyJSON.objJoin(";
			for ( var i = 0; i < a.length; i++) {
				if (i > 0) {
					x += ","
				}
				;
				x += 'a[' + i + ']'
			}
			;
			return eval(x + ",this)")
		};
		Object.prototype.objJoin = x;
		eval("x=" + (x + "").replace(/objJoin/g, "inherit"));
		Function.prototype.inherit = x;
		Function.prototype.privateMembers = function(x) {
			return classyJSON.privateMembers(this, x)
		};
		Function.prototype.privateMemberTypes = function(x) {
			return classyJSON.privateMembers(this, x, "type")
		};
		Function.prototype.publicMembers = function(x) {
			return classyJSON.privateMembers(this, x, "not")
		};
		Function.prototype.publicMemberTypes = function(x) {
			return classyJSON.privateMembers(this, x, "notType")
		}
	}
};
classyJSON.extendPrototypes();