const fs = require('fs');
const readline = require('readline');

if(!process.argv[2]) {
  console.log("No input file!");
  process.exit(-1);
}

const rl = readline.createInterface({
  input: fs.createReadStream(process.argv[2]),
  crlfDelay: Infinity
});

let nameCheck = {};
let names = [];
let times = [];
let dataMap = {};

rl.on('line', (line) => {
  const info = JSON.parse(line);
  times.push(info.requestTime);
  info.arguments.torrents.forEach((torrent) => {
    if(!nameCheck[torrent.name]) {
      nameCheck[torrent.name] = 1;
      names.push(torrent.name);
    }
    if(!dataMap[torrent.name]) {
      dataMap[torrent.name] = {};
    }
    dataMap[torrent.name][info.requestTime] = torrent.uploadRatio;
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
        xAxis: {type: 'time', boundaryGap: false},
        yAxis: {type: 'value'},
        dataZoom: [{show: false, start: 0, end: 100},{type: 'inside', start: 0, end: 100}],
        legend: {
          show: false,
          data: `);
  console.log(names);
  console.log(`},
  series: [`);
  let i = 0;
  names.forEach((name) => {
    obj = {
      name: name,
      type: 'line',
      symbolSize: 10,
      data: []
    };
    times.forEach((time) => {
      arr = [];
      arr.push(time*1000);
      arr.push(dataMap[name][time]);
      obj.data.push(arr);
    });
    if(i) {
      console.log(',');
    }
    i++;
    console.log(obj);
  });
  console.log(`]
};
myChart.setOption(option);
</script>
</body>
</html>`)
});
