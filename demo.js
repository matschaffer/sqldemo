var db = openDatabase("sqlDemo", "1.0", "A database for doing sql demos.");

function header(rows) {
  var headers = ["<thead><tr>"];
  for (i in rows.item(0)) {
    headers.push(["<th>", i, "</th>"].join(''));
  }
  headers.push("</tr></thead>");
  return headers.join('');
}

function body(rows) {
  var b = ["<tbody>"];
  for (var i = 0; i < rows.length; i++) {
    var item = rows.item(i);
    b.push("<tr>");
    for (key in item) {
      b.push("<td>", item[key], "</td>");
    }
    b.push("</tr>");
  }
  b.push("</tbody>");
  return b.join('');
}

function s(query, params) {
  db.transaction(function(tx) {
    tx.executeSql(query, params, function(tx, results) {
      var t = $('#results');
      var rows = results.rows;
      if (rows.length > 0) {
        t.html(header(rows));
        t.append(body(rows));
      } else {
        t.html("<thead><tr><td>No data to display</td></tr></thead>");
      }
      console.log(results.rowsAffected + " rows affected.");
    },
    function(tx, e) {
      console.error(["Query Error ", "[", e.code , "]:  ", e.message].join(''));
    });
  },
  function(e) {
    console.error(["Transaction Error ", "[", e.code , "]:  ", e.message].join(''));
  },
  function() {
    console.info("Transaction complete");
  });
}

$(function() {
  $('#run').click(function() {
    s(this.form['scratchpad'].value);
  });

  function isMeta(code) {
    return code == "91" || code == "93";
  }

  var meta = false;
  $('#scratchpad').keyup(function(e) {
    if (isMeta(e.keyCode)) {
      meta = false;
    }
  }).keydown(function(e) {
    if (isMeta(e.keyCode)) {
      meta = true;
    } else if (meta && e.keyCode == "13") {
      $('#run').click();
    }
  });
});