<?php
/*************************************************************************
    > File Name: netease-cloud-music-download.php
    > Author: nian
    > Blog: https://whoisnian.com
    > Mail: zhuchangbao2017@gmail.com
    > Created Time: 2017年08月05日 星期六 22时49分28秒
    >
    > Description: Download songs in netease-cloud-music.
    > Need: PHP, wget.
    > Others: You can change the file name format in line 75.
    > Website: http://music.whoisnian.com
 ************************************************************************/

echo "请输入歌曲ID：\n";
fscanf(STDIN, "%s", $id);

if(ctype_digit($id)) {
	$url = "http://music.163.com/api/song/detail/?id=".$id."&ids=[".$id."]";
	$json = get_by_curl($url);
	$song_detail = json_decode($json, true);
		
	// Thanks to https://github.com/maicong/music/blob/master/music.php
	$other_url = "http://music.163.com/api/song/enhance/player/url?ids=[".$id."]&br=320000";
	$other_json = get_by_curl($other_url);
	$other_link = json_decode($other_json, true);
}
else {
	echo "歌曲ID错误！\n";
	exit();
}

if($song_detail["songs"] != NULL && array_key_exists("album", $song_detail["songs"][0]) && $song_detail["code"] == 200) {
	$url = "http://music.163.com/api/album/".$song_detail["songs"][0]["album"]["id"]."?id=".$song_detail["songs"][0]["album"]["id"];
	$json = get_by_curl($url);
	$album = json_decode($json, true);

	foreach($album["album"]["songs"] as $song) {
		if($song["id"] == $id)
			break;
	}

	if(array_key_exists("mp3Url", $song) && $song["mp3Url"] != null) {
		$link = str_replace("http://m2", "http://p2", $song["mp3Url"]);
	}
	else if($song["mMusic"]["dfsId"] != 0) {
		$link = "http://p2.music.126.net/".encrypt_id($song["mMusic"]["dfsId"])."/".$song["mMusic"]["dfsId"].".mp3";
	}
	else {
		$link = "http://p2.music.126.net/".encrypt_id($song["bMusic"]["dfsId"])."/".$song["bMusic"]["dfsId"].".mp3";
	}

	if($other_link["data"][0]["url"] != NULL) {
		$link = $other_link["data"][0]["url"];
	}
	else if(!substr_count(get_headers($link)[0], '200')) {
		echo "歌曲下载失败！\n";
		exit();
	}
}
else {
	echo "未查询到歌曲！\n";
	exit();
}

$Name = $song["name"];
$Artist = "";
foreach($song["artists"] as $i=>$artist) {
	$Artist = $Artist.($i == 0 ? "":"/");
	$Artist = $Artist.$artist["name"];
}

/*********************************************
  You can change song name as you like here.
**********************************************/
$FileName = $Name.".mp3";

exec("wget -c $link -O $FileName -q --show-progress");

function get_by_curl($url) {
	$ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_COOKIE, "appver=1.5.0.75771");
	curl_setopt($ch, CURLOPT_REFERER, "http://music.163.com/");
    $data = curl_exec($ch);
    curl_close($ch);
    return $data;
}
// Thanks to https://github.com/metowolf/Meting/blob/master/src/Meting.php
function encrypt_id($id) {
    $str1 = str_split('3go8&$8*3*3h0k(2)2');
    $str2 = str_split($id);
    for($i = 0;$i < count($str2);$i++) {
        $str2[$i] = chr(ord($str2[$i]) ^ ord($str1[$i % count($str1)]));
    }
    $result = base64_encode(md5(implode('', $str2), true));
    $result = str_replace(array('/','+'), array('_','-'), $result);
    return $result;
}

?>
