---
---

window.Existibot =

  main:
    init: (ExistibotSettings) ->
      
      @headerScroll()

      @analytics()
      
      @facebookInit()
      @twitterInit()

      Existibot.comic.init() if ExistibotSettings.comic

    analytics: ->

      # logo click
      headerImg = document.querySelector('.header__core__img')
      headerImg.addEventListener( 'click', ->
        ga_event_track('Header','Click','Logo')
      ) if headerImg

      # index selector usage
      comicList = document.querySelector('.comicList')
      if comicList
        [].forEach.call( comicList.querySelectorAll('.comicList__link'), (thisComic) ->
          
          thisComic.addEventListener( 'click', ->
            ga_event_track('Comic Index','Click',"#{ thisComic.innerHTML }")
          )
        )

      # prev/next links
      comicMenu = document.querySelector('.comicMenu')
      if comicMenu

        linkPrev = comicMenu.querySelector('.comicMenu__link--prev')
        linkNext = comicMenu.querySelector('.comicMenu__link--next')

        linkPrev.addEventListener( 'click', ->
          ga_event_track('Comic Nav','Click',"Previous Click: #{ this.getAttribute('data-comictitle') }")
        ) if linkPrev

        linkNext.addEventListener( 'click', ->
          ga_event_track('Comic Nav','Click',"Next Click: #{ this.getAttribute('data-comictitle') }")
        ) if linkNext

      # footer link
      footer_link = document.querySelector('.footer__core__link')
      footer_link.addEventListener( 'click', ->
        ga_event_track('Footer','Click',"Footer Link Click: #{ this.title }")
      ) if footer_link

      # facebook like/unlike/share
      window.facebook_like_funk = (href) ->
        ga_event_track('Facebook','Like',href)

      window.facebook_unlike_funk = (href) ->
        ga_event_track('Facebook','Unlike',href)

      # twitter share
      window.twitter_tweet_funk = (href) ->
        ga_event_track('Twitter','Tweet',href)


    facebookInit: ->

      window.fbAsyncInit = ->
        FB.init
          appId: '669690993161573'
          xfbml: true
          version: 'v2.4'

        FB.Event.subscribe( 'edge.create', facebook_like_funk )
        FB.Event.subscribe( 'edge.remove', facebook_unlike_funk )

        return

      ((d, s, id) ->
        js = undefined
        fjs = d.getElementsByTagName(s)[0]
        if d.getElementById(id)
          return
        js = d.createElement(s)
        js.id = id
        js.src = '//connect.facebook.net/en_US/sdk.js'
        fjs.parentNode.insertBefore js, fjs
        return
      ) document, 'script', 'facebook-jssdk'

    twitterInit: ->

      window.twttr = ( ( d, s, id ) =>
        t = undefined
        js = undefined
        fjs = d.getElementsByTagName( s )[ 0 ]
        return if d.getElementById( id )

        js = d.createElement( s )
        js.id = id
        js.src = 'https://platform.twitter.com/widgets.js'
        fjs.parentNode.insertBefore( js, fjs )
        window.twttr or ( t =
          _e: []
          ready: ( f ) ->
            t._e.push( f )
        )

      )( document, 'script', 'twitter-wjs' )

      twttr.ready( ( twttr ) ->
        # twttr.events.bind( 'follow', ( e ) ->
        #   console.debug 'follow'
        # )
        # twttr.events.bind( 'unfollow', ( e ) ->
        #   console.debug 'unfollow'
        # )
        twttr.events.bind( 'tweet', ( e ) ->
          twitter_tweet_funk(e.target.baseURI)
        )
      )

    headerScroll: ->

      _t = this

      _t.headerCore = document.querySelector('.header__core')

      # if user scrolls down past 20px,
      # shrink the header for design.
      document.addEventListener('scroll', (e) ->
        window.hasScrolled = true
      )

      _t.siteInterval = setInterval( ->
        if window.hasScrolled
          st = window.pageYOffset | document.body.scrollTop
          window.hasScrolled = false
          _t.scrollCheck(st)

      , 250)

      # ga_event_track 'pie', 'pies', 'pied'

    scrollCheck: (st) ->

      _t = this

      # resize header
      if st > 100
        _t.headerCore.classList.add('is-scrolling')
      else
        _t.headerCore.classList.remove('is-scrolling')

  comic:
    init: ->

      # run basic functions
      @sizeComics()

    sizeComics: ->

      [].forEach.call( document.querySelectorAll('.comicContainer'), (thisCC) ->

        h = []

        allSpans = thisCC.querySelectorAll('span')

        [].forEach.call( allSpans, (thisSpan) ->
          h.push(thisSpan.offsetHeight)
        )

        h = h.sort( (a, b) ->
          a - b
        )

        [].forEach.call( allSpans, (thisSpan) ->
          thisSpan.style.height = "#{ h[h.length - 1] }px"
        )
      )

  # bakery make cookies!!1

  bakery:
    create: ( name, value, days ) ->
      exp = ""
      if days
        date = new Date()
        date.setTime( date.getTime() + ( days * 24 * 60 * 60 * 1000 ) )
        exp = "; expires=#{ date.toGMTString() }"
      document.cookie = "#{ name }=#{ value }#{ exp }; path=/"

    read: ( name ) ->
      nameEQ = "#{ name }="
      ca = document.cookie.split( ';' )

      i = 0
      while i < ca.length
        c = ca[ i ]
        c = c.substring( 1, c.length ) while c.charAt( 0 ) is ' '
        return c.substring( nameEQ.length, c.length ) if c.indexOf( nameEQ ) is 0
        i++
      null

    erase: ( name ) ->
      createCookie( name, '', -1 )
