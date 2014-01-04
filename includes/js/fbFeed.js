var _facebookUserCache = {};
var _maxFeedPosts = 10;
var _accessToken = 0;
var _FBEnabled = false;

$(document).ready( function() {
	$.ajaxSetup({ cache: true });

	$.getScript('//connect.facebook.net/en_UK/all.js', function() {
		_FBEnabled = true;

		FB.init({
			appId: '272812729524274',
			channelUrl: '//www.finealley.com/channel.html',
		});
		FB.getLoginStatus(function(response) {
		    if (response.authResponse) { _accessToken = response.authResponse.accessToken; }
			buildFeed(_accessToken);
		});	
		console.log(_FBEnabled);
	});
	console.log(_FBEnabled);
	
});

function buildFeed(accessToken) {
	_accessToken = accessToken;
	if (_FBEnabled) {
		if (_accessToken && _accessToken != 0) {
			FB.api('/417727031647789?access_token=' + _accessToken + '&fields=feed.limit(10).fields(message,link,icon,picture,comments,likes,from,full_picture,type,actions,story),likes,name,link,picture', function(json) {
				//console.log(json);
				if (json.feed) {
					$('div.facebookFeed').html(drawFaceBookFeed(json));
				} 
			});			
		} else {
			FB.api('/417727031647789?fields=booking_agent,current_location,category,genre,talking_about_count,id,cover,name,link,likes,picture', function(json) {
				//console.log(json);
				if (!json.error) {
					$('div.facebookFeed').html(drawFaceBookFeed(json));
				}
			});			
		}
	}
}

function drawFaceBookFeed(_data) {
	//console.log(_data);

	var _box = $('<div/>');
	var _header = $('<header/>')
		.append($('<img/>').attr('src',_data.picture.data.url))
		.append($('<h3>').text(_data.name))
		.append($('<div/>').addClass('likes')
			.append($('<span/>').addClass('count').text(_data.likes))
			.append($('<span/>').addClass('text').text('likes'))
		);

	_facebookUserCache[_data.id]= { 
		name:_data.name,
		image: _data.picture.data.url,
		link: _data.link
	};

	//console.log(_facebookUserCache);

	var _footer = $('<footer/>')
		.append($('<a/>').attr('href',_data.link).text("see more on Facebook"));

	var _body = $('<div/>').addClass('feed');
	var _postCount = 0;
	if (_data.feed) {
		for (var i in _data.feed.data) {
			if ((_data.feed.data[i].type != "link") && (_postCount < _maxFeedPosts)) {
				_postCount++;
				_body.append(drawFacebookFeedPost(_data.feed.data[i]));
			}
		}
	} else {
		_body.append(
			$('<p/>').text(' to login to facebook to see more information.')
				.prepend($('<a/>')
						.attr('href',_data.link)
						.text('click here').on('click',function(e) {
							e.preventDefault();
							FB.login(function(response) {
								if (response.authResponse) { buildFeed(response.authResponse.accessToken); }
							});
						})
				)
			);
	}

	return _box.append(_header).append(_body).append(_footer);
}
function drawFacebookFeedPost(_data) {
	//console.log(_data);
	var _post = $('<div/>').addClass('post');
	var _postHeader = $('<header/>');
	if (_data.from) { 
		_postHeader.append(drawPerson(_data.from.id,_data.from.name));
	}
	if (_data.created_time) { 
		_postHeader.append($('<p/>').text(drawFormatedDate(_data.created_time)).addClass('postDate')); 
	}	

	var _postBody = $('<div/>').addClass('body');

	if (_data.picture) { 
		var _img = $('<img/>').attr('src',_data.picture).addClass('img-polaroid');
		if (_data.link) {
			_img = $('<a/>').attr('href',_data.link).append(_img);
		}
		_postBody.append(_img); 
	}
	
	if (_data.message) { _postBody.append($('<p/>').text(_data.message)); }
	if (_data.story) { _postBody.append($('<p/>').text(_data.story)); }

	var _postFooter = $('<footer/>');
	if (_data.likes) { _postFooter.append($('<p>').text((_data.likes.data.length+1) + ' likes')) }
	
	
	if (_data.comments) {
		var _comments = $('<div>').addClass('comments').append($('<p/>').text('Comments'));
		for (var i in _data.comments.data) {
			_comments.append(drawFacebookComment(_data.comments.data[i]));
		}
		_postFooter.append(_comments);
	}
	

	if (_data.actions) {
		var _actions = $('<ul/>').addClass('actions');
		for (var i in _data.actions) {
			_actions.append($('<li/>').append($('<a/>').attr('href',_data.actions[i].link).text(_data.actions[i].name)));
		}
		_postFooter.append(_actions);
	}

	_post.append(
		$('<div>').addClass('details')
			.append(_postHeader)
			.append(_postBody)
			.append(_postFooter)
	);
	
	return _post;
}

function drawFacebookComment(_data) {
	//console.log(_data);
	var _comment = $('<div/>').addClass('comment');

	if (_data.from) {
		_comment.append(drawPerson(_data.from.id,_data.from.name));
	}
	if (_data.created_time) { 
		_comment.append($('<p/>').text(drawFormatedDate(_data.created_time)).addClass('postDate')); 
	}	

	if (_data.message) {
		_comment.append($('<p/>').text(_data.message).addClass('message'));
	}

	return _comment;
}
function drawPerson(_id,_nameOnFail) {
	if (!_facebookUserCache[_id]) {
		if (!_nameOnFail) { _nameOnFail = "Unknown"; }
		_facebookUserCache[_id]= { 
			name: _nameOnFail
		};
		var _person	= drawPersonDetails(_facebookUserCache[_id]);
		if (_FBEnabled) {
			FB.getLoginStatus(function(response) {
				if (response.authResponse) {
					FB.api('/' + _id + '?fields=cover,link,name,id,picture&access_token=' + _accessToken, function(json) {
						//console.log(json);
						if (json.name) { _facebookUserCache[_id].name = json.name; }
						if (json.picture) { _facebookUserCache[_id].image = json.picture.data.url; }
						if (json.link) { _facebookUserCache[_id].link = json.link; }
						_person.html(drawPersonDetails(_facebookUserCache[_id]).html());
					}); // close FB API
				} // close if response
			}); // close FB Response
		}
		return _person;
	} else {
		return drawPersonDetails(_facebookUserCache[_id]);
	} // close if
}
function drawPersonDetails(_data) {
	var _person	= $('<div>').addClass('person');
	if (_data.image) {
		_person.append($('<img>').attr('src',_data.image));
	} else {
		_person.append($('<img>').attr('src','/includes/img/facelessUser.jpg'));
	}
	if (_data.name) {
		var _name = $('<p>').addClass('name');
		if (_data.link) { 
			_name.append($('<a/>').attr('href',_data.link).text(_data.name));
		} else {
			_name.text(_data.name);
		}
		_person.append(_name);
	}
	return _person;
}
function drawFormatedDate(_date) {
	//console.log("Start Date: " + _date);
	var _regEx = /(\d{2,4})[^\d]+(\d{1,2})[^\d]+(\d{1,2})[^\d]+(\d{1,2})[^\d]+(\d{1,2})[^\d]+(\d{1,2})[^\d]+(\d{4})?/gi;
	var _year = _date.replace(_regEx,"$1");
	var _month = _date.replace(_regEx,"$2")-1;
	var _day = _date.replace(_regEx,"$3");
	var _hour = _date.replace(_regEx,"$4");
	var _min = _date.replace(_regEx,"$5");
	var _sec = _date.replace(_regEx,"$6");	

	var _tDate = new Date();
	var _oDate = new Date(_year,_month,_day,_hour,_min,_sec,0);
	_oDate.setMinutes(_oDate.getMinutes()-_tDate.getTimezoneOffset());
	//console.log("Created Date: " + _oDate);

	var _months = ["Jan","Feb","Mar","Apr","May","June","July","Aug","Sept","Oct","Nov","Dec"];

	return _months[_oDate.getMonth()] + ' ' + _oDate.getDate() + ' ' + _oDate.getFullYear() + ' @ ' + _oDate.getHours() + ':' + _oDate.getMinutes();

}