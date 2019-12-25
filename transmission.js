const fs = require('fs');
const readline = require('readline');

const identify = function(torrent) {
  return torrent.addedDate + "_" + torrent.name + "_" + torrent.totalSize;
}

if(!process.argv[2]) {
  console.log("No input file!");
  process.exit(-1);
}

const rl = readline.createInterface({
  input: fs.createReadStream(process.argv[2]),
  crlfDelay: Infinity
});

let torrentCheck = {};
let torrents = [];
let seriesMap = {};
let timeNow = Date.now();

rl.on('line', (line) => {
  const info = JSON.parse(line);
  info.arguments.torrents.forEach((torrent) => {
    if(!torrentCheck[identify(torrent)]) {
      torrentCheck[identify(torrent)] = 1;
      torrents.push(identify(torrent));
    }
    if(!seriesMap[identify(torrent)]) {
      seriesMap[identify(torrent)] = {
        name: torrent.name,
        type: 'line',
        symbolSize: 10,
        data: []
      };
      if(timeNow-torrent.addedDate*1000 <= 7*24*60*60*1000) {
        seriesMap[identify(torrent)].data.push([torrent.addedDate*1000, 0]);
      }
    }
    if(timeNow-info.requestTime*1000 <= 7*24*60*60*1000) {
      seriesMap[identify(torrent)].data.push([info.requestTime*1000, torrent.uploadedEver/torrent.totalSize]);
    }
  });
});

rl.on('close', () => {
  console.log(`<html>
  <head>
    <meta charset="utf-8">
    <title>ratio</title>
    <script src="https://cdn.jsdelivr.net/npm/echarts@4.5.0/dist/echarts.min.js"></script>
  </head>
  <body>
    <div id="main" style="width:100%;height:100%;"></div>
    <script type="text/javascript">
      var myChart = echarts.init(document.getElementById('main'));
      var option = {
        tooltip: {trigger: 'item', formatter: function(params){d=new Date(params.data[0] +8 *3600000);return params.seriesName+'<br/>'+d.toISOString().substring(0, 16).replace('T', ' ')+' UTC+08:00<br/>'+params.data[1]}},
        dataZoom: [{type: 'slider', xAxisIndex: 0, filterMode: 'empty'}, {type: 'slider', yAxisIndex: 0, filterMode: 'empty'}],
        xAxis: {type: 'time', boundaryGap: false},
        yAxis: {type: 'value'},`);
  console.log(`series: [`);
  let i = 0;
  torrents.forEach((identification) => {
    if(i) {
      console.log(',');
    }
    i++;
    console.dir(seriesMap[identification], {'maxArrayLength': null});
  });
  console.log(`]
};
myChart.setOption(option);
</script>
</body>
</html>`)
});
