var bubblesort = function (items) {
  var done = false;
  var i, temp;
  while (!done) {
    done = true;
    for (i = 1; i < items.length; i++) {
      if (items[i - 1] > items[i]) {
        done = false;
        temp = items[i - 1];
        items[i - 1] = items[i];
        items[i] = temp;
      }
    }
  }
  return items;
};
