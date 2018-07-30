document.addEventListener('DOMContentLoaded', function () {

  var muuri = null;
  var docElem = document.documentElement;
  var muix = document.querySelector('.muuri-index');
  var board = muix.querySelector('.board');
  var itemContainers = muix.querySelector('.board-column-content');
  var columnGrids = [];
  var dragCounter = 0;
  var boardGrid;
  var muuri = new Muuri(itemContainers, {
    items: '.board-item',
    layoutDuration: 400,
    layoutEasing: 'ease',
    dragEnabled: true,
    dragSortInterval: 0,
    dragSortGroup: 'column',
    dragSortWith: 'column',
    dragStartPredicate: {
      handle: '.content'
    },//触摸位置
    dragContainer: document.body,
    dragReleaseDuration: 400,
    dragReleaseEasing: 'ease'
  })
  .on('dragStart', function (item) {
    ++dragCounter;
    docElem.classList.add('dragging');
    //console.log(this);
    item.getElement().style.width = item.getWidth() + 'px';
    item.getElement().style.height = item.getHeight() + 'px';
  })
  .on('dragEnd', function (item) {
    if (--dragCounter < 1) {
      docElem.classList.remove('dragging');
    }
  })
  .on('dragReleaseEnd', function (item) {
    item.getElement().style.width = '';
    item.getElement().style.height = '';
    columnGrids.forEach(function (muuri) {
      muuri.refreshItems();
    });
  })
  .on('layoutStart', function () {
    initGrid();
    boardGrid.refreshItems().layout();
  });

  columnGrids.push(muuri);

  function initGrid() {
    boardGrid = new Muuri(board, {
      layoutDuration: 400,
      layoutEasing: 'ease',
      dragEnabled: true,
      dragSortInterval: 0,
      dragStartPredicate: {
        handle: '.board-column-header'
      },
      dragReleaseDuration: 400,
      dragReleaseEasing: 'ease'
    })
    .on('dragStart', function () {
      ++dragCounter;
      docElem.classList.add('dragging');
    })
    .on('dragEnd', function () {
      if (--dragCounter < 1) {
        docElem.classList.remove('dragging');
      }
    })
    .on('move', updateIndices)
    .on('sort', updateIndices);
  }


  $('.board').on('click', '.card-remove', function(e){

    //console.log(e);
    //$(this).parent().parent().hide();
    //$(this).parent().parent().remove();
    //$(".board-column-content").height();
    removeItem(e);
  })

  function removeItem(e) {

    var elem = elementClosest(e.target, '.board-item');
    muuri.hide(elem, {onFinish: function (items) {
      var item = items[0];
      muuri.remove(item, {removeElements: true});
      //if (sortFieldValue !== 'order') {
      //  var itemIndex = dragOrder.indexOf(item);
      //  if (itemIndex > -1) {
      //    dragOrder.splice(itemIndex, 1);
      //  }
      //}
    }});
    updateIndices();

  }

  function elementClosest(element, selector) {

    if (window.Element && !Element.prototype.closest) {
      var isMatch = elementMatches(element, selector);
      while (!isMatch && element && element !== document) {
        element = element.parentNode;
        isMatch = element && element !== document && elementMatches(element, selector);
      }
      return element && element !== document ? element : null;
    }
    else {
      return element.closest(selector);
    }

  }

  $(".add-item").on("click", function() {
    var title = $(this).html();
    var cls = $(this).data('class');
    //console.log(cls);

    if($("div[data-mk='"+cls+"']").html()&&cls!='fg'){
      alert('已接添加过');
      return;
    }

    var newElems = [];
    var itemElem = document.createElement('div');
    var itemTemplate = '<div class="board-item">'+
        '<div class="board-item-content">'+
        '<div class="content"><div class="mks" data-mk="'+cls+'"><img src="/app/shop/static/images/'+cls+'.png"></div></div>'+
        '<div class="card-remove"><span class="am-icon-close"></span></div>'+
        '</div>'+
        '</div>';
    itemElem.innerHTML = itemTemplate;
    newElems.push(itemElem.firstChild);

    var newItems = muuri.add(newElems);

    updateIndices();
  });




  function updateIndices() {

    muuri.getItems().forEach(function (item, i) {
      //item.getElement().setAttribute('data-id', i + 1);
      //item.getElement().querySelector('.card-id').innerHTML = i + 1;
    });

  }

});