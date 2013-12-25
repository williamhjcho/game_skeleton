<!--
function QueryObject(location) {
	var location = location.substring(1);
	var queries = location.split("&");
	while (queries.length) {
		var query = queries.pop();
		var name = query.split("=")[0];
		var value = query.split("=")[1];
		this[name] = value;
	}
}
-->