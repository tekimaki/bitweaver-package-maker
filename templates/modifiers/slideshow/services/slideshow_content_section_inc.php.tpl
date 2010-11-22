
				//Generate slideshow hash for {{$typemapName}}
				$pObject->mInfo['{{$typemapName}}_slideshow'] = array();
				foreach($pObject->mInfo['{{$typemapName}}'] as $key=>$image){
					if($image['{{$config.name}}_image_slideshow_inc']){
						$imageHash = array();
						$imageHash['image_id'] = $image['{{$config.name}}_image_id'];
						$imageHash['content_id'] = $image['content_id'];
						$imageHash['image_caption'] = $image['{{$config.name}}_image_caption'];
						$pObject->mInfo['{{$typemapName}}_slideshow'][] = $imageHash;
					}
				}
				global $gBitThemes;
				$gBitThemes->loadJavascript( UTIL_PKG_PATH.'javascript/colorbox/jquery.colorbox.js', TRUE, 101 );
				$gBitThemes->loadCss( UTIL_PKG_PATH.'javascript/colorbox/colorbox.css',FALSE,304, FALSE, FALSE);
