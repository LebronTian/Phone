function formatTime(phpDate) {
    var date = new Date(parseInt(phpDate) * 1000);
    var year = date.getFullYear();
    var month = formatNumber(date.getMonth() + 1);
    var day = formatNumber(date.getDate());

    var hour = date.getHours()
    var minute = date.getMinutes()

    // var date = formatNumber(month) + "月" + formatNumber(day) + "日 ";
    var time = formatNumber(hour) + ":" + formatNumber(minute);

    return [year, month, day, time];
}

function formatRemainTime(phpDate) {
    var day = Math.floor(phpDate / 86400),
        hour = Math.floor(phpDate % 86400 / 3600),
        min = Math.floor(phpDate % 3600 / 60),
        sec = phpDate % 60;

    var time = day + "天 " + formatNumber(hour) + "小时 " + formatNumber(min) + "分钟 " + formatNumber(sec) + "秒";

    return time;
}

// 将价格转换为小数点后两位格式
function formatPrice(price) {
    price = parseFloat(price / 100);
    return price == 0 ? "免费" : (price.toFixed(2) + " 元");
}

function formatNumber(n) {
  n = n.toString()
  return n[1] ? n : '0' + n
}

module.exports = {
  formatTime: formatTime,
  formatRemainTime: formatRemainTime,
  formatPrice: formatPrice
}
