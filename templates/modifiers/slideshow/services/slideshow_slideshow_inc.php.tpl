
				//Generate slideshow hash for {{$typemapName}}
				$pObject->mInfo['{{$typemapName}}_slideshow'] = array();
				foreach($pObject->mInfo['{{$typemapName}}'] as $key=>$image){
					if($image['{{$typemap.modifier.slideshow.image_slideshow_inc.$typemapName}}']){
						$imageHash = array();
						$imageHash['image_id'] = $image['{{$typemap.modifier.slideshow.image_id.$typemapName}}'];
						$imageHash['content_id'] = $image['content_id'];
						$imageHash['image_caption'] = $image['{{$typemap.modifier.slideshow.caption.$typemapName}}'];
						$pObject->mInfo['{{$typemapName}}_slideshow'][] = $imageHash;
					}
				}
				global $gBitThemes;
				$gBitThemes->loadJavascript( UTIL_PKG_PATH.'javascript/colorbox/jquery.colorbox.js', TRUE, 101 );
				$gBitThemes->loadCss( UTIL_PKG_PATH.'javascript/colorbox/colorbox.css',FALSE,304, FALSE, FALSE);
