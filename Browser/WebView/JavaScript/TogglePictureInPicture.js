//
//  TogglePictureInPicture.js
//  Browser
//
//  Created by Leonardo Larrañaga on 3/24/25.
//

(async function () {
    function findMediaElement() {
        let video = document.querySelector('video')
        if (video) return video

        let iframe = document.querySelector('iframe')
        if (iframe) {
            try {
                let innerDoc = iframe.contentDocument || iframe.contentWindow.document
                return innerDoc.querySelector('video')
            } catch (e) {
                // console.error('No access to iframe content:', e)
                return null
            }
        }
        return null
    }

    let mediaElement = findMediaElement()

    if (!mediaElement) {
        // console.error('No media element found.')
        return
    }

    let isPlaying = !mediaElement.paused && !mediaElement.ended
    let hasAudio = mediaElement.muted === false && mediaElement.volume > 0

    if (isPlaying && hasAudio && document.pictureInPictureEnabled) {
        if (!document.pictureInPictureElement) {
            await mediaElement.requestPictureInPicture()
        } else {
            await document.exitPictureInPicture()
        }
    } else {
        // console.error('Media is either not playing, muted, or has no audio.')
    }
})()
