
export function initializeVimeoPlayer() {
  const videoElements = document.querySelectorAll('[data-video-id]');

  videoElements.forEach((videoElement) => {
    const videoId = videoElement.dataset.videoId;
    const player = new Vimeo.Player(videoElement);

    // ここでサーバーから最後の再生時間を取得
    fetch(`/user/video_views/${videoId}`)
      .then(response => response.json())
      .then(data => {
        console.log(data)
        if (data.last_play_time) {
          player.setCurrentTime(data.last_play_time);
        }
      });

      let intervalId;

      player.on('play', function() {
        intervalId = setInterval(function() {
          console.log('10seconds')
          sendCurrentTimeToServer(player, videoId);
        }, 10000); // 10秒ごとに再生時間を取得し、サーバーに送信します
      });
  
      player.on('pause', function() {
        console.log('pause')
        clearInterval(intervalId);
        sendCurrentTimeToServer(player, videoId);
      });
  
      player.on('ended', function() {
        console.log('ended')
        clearInterval(intervalId);
        moveNextVideo(videoId)
      });
  });

  window.onresize = function() {
    const container = document.querySelector(".video-container");
    container.style.height = window.innerHeight + "px";
    container.style.width = window.innerWidth + "px";
  }
}

function sendCurrentTimeToServer(player, videoId) {
  player.getCurrentTime().then(function(seconds) {
    var time = seconds;
    console.log(time);

    fetch('/user/video_views', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
      },
      body: JSON.stringify({ time: time, video_id: videoId })
    })
    .then(response => response.json())
    .then(data => {
      console.log("Time saved successfully");
    })
    .catch((error) => {
      console.error('Error:', error);
    });
  }).catch(function(error) {
    console.error('Failed to get the current time:', error);
  });
}

const moveNextVideo = (videoId) => {
  window.location.href = `/articles/${Number(videoId)+1}`;
}