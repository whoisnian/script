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
    > Others: You can change the default file name format in line 155.
    > Website: http://music.whoisnian.com/netease/
 ************************************************************************/

echo "1.下载单曲。\n";
echo "2.下载专辑。\n";
echo "3.下载歌单。\n";
echo "0.退出。\n";
fscanf(STDIN, "%s", $choice);

switch($choice) {
case "1":
	a_song();
	break;
case "2":
	a_album();
	break;
case "3":
	a_playlist();
	break;
default:
	echo "已退出。\n";
	exit();
}

function a_song() {
	echo "请输入歌曲ID:\n";
	fscanf(STDIN, "%s", $id);
	if(ctype_digit($id)) {
		download($id);
		exit();
	}
	else {
		echo "歌曲ID错误！\n";
		exit();
	}
}

function a_album() {
	echo "请输入专辑ID:\n";
	fscanf(STDIN, "%s", $id);
	if(ctype_digit($id)) {
		$url = "http://music.163.com/api/album/".$id."?id=".$id;
		$json = get_by_curl($url);
		$album = json_decode($json, true);
		if(array_key_exists("album", $album) && $album["album"]["size"] > 0) {
			foreach($album["album"]["songs"] as $index=>$song) {
				echo "正在下载第".($index+1)."/".$album["album"]["size"]."首歌曲\n";
				download($song["id"]);
			}
			echo "下载完成。\n";
			exit();
		}
		else {
			echo "未查询到专辑！\n";
			exit();
		}
	}
	else {
		echo "专辑ID错误！\n";
		exit();
	}
}

function a_playlist() {
	echo "请输入歌单ID:\n";
	fscanf(STDIN, "%s", $id);
	if(ctype_digit($id)) {
		$url = "http://music.163.com/api/playlist/detail?id=".$id;
		$json = get_by_curl($url);
		$playlist = json_decode($json, true);
		if(array_key_exists("result", $playlist) && $playlist["result"]["trackCount"] > 0) {
			foreach($playlist["result"]["tracks"] as $index=>$song) {
				echo "正在下载第".($index+1)."/".$playlist["result"]["trackCount"]."首歌曲\n";
				download($song["id"]);
			}
			echo "下载完成。\n";
			exit();
		}
		else {
			echo "未查询到歌单！\n";
			exit();
		}
	}
	else {
		echo "歌单ID错误！\n";
		exit();
	}
}

function download($id) {
	$url_1 = "http://music.163.com/api/song/detail/?id=".$id."&ids=[".$id."]";
	$json_1 = get_by_curl($url_1);
	$song_detail_1 = json_decode($json_1, true);
		
	$url_2 = "http://music.163.com/api/song/enhance/player/url?ids=[".$id."]&br=320000";
	$json_2 = get_by_curl($url_2);
	$song_detail_2 = json_decode($json_2, true);

	if($song_detail_1["songs"] != NULL && $song_detail_1["code"] == 200) {
		if($song_detail_2["data"][0]["url"] != NULL && substr_count(get_headers($song_detail_2["data"][0]["url"])[0], '200')) {
			$link = $song_detail_2["data"][0]["url"];
		}
		else {
			$url_3 = "http://music.163.com/api/album/".$song_detail_1["songs"][0]["album"]["id"]."?id=".$song_detail_1["songs"][0]["album"]["id"];
			$json_3 = get_by_curl($url_3);
			$album_detail_3 = json_decode($json_3, true);

			foreach($album_detail_3["album"]["songs"] as $song) {
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
		}
	}
	else {
		echo "未查询到歌曲！\n";
		exit();
	}

	if(!substr_count(get_headers($link)[0], '200')) {
		echo "歌曲下载失败！\n";
		exit();
	}

	$Name = $song_detail_1["songs"][0]["name"];
	$Artist = "";
	foreach($song_detail_1["songs"][0]["artists"] as $i=>$artist) {
		$Artist = $Artist.($i == 0 ? "":"/");
		$Artist = $Artist.$artist["name"];
	}

	/*********************************************
	  You can change song name as you like here.
	**********************************************/
	$FileName = $Name.".mp3";
	//$FileName = $Artist.$Name.".mp3";
	//$FileName = $Name.$Artist.".mp3";

	exec("wget -c '$link' -O '$FileName' -q --show-progress");
}

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
