var _user$project$Native_Accordion = (function() {
    var prevTab;

    function closeOnEnd() {
        this.style.display = 'none';
    }

    function resetHeight() {
        this.style.height = '';
    }

    function openTab(domSelector) {
        var tab = document.querySelector(domSelector)
        if (tab === prevTab) {
            return;
        }
        prevTab = tab;
        var contentOuter = tab && tab.querySelector('.tabContentOuter');
        var contentInner = tab && contentOuter && contentOuter.querySelector('.tabContentInner');


        if (contentOuter && contentInner) {
            contentOuter.style.display = '';
            contentOuter.style.height = 0;

            contentOuter.removeEventListener('transitionend', closeOnEnd);
            setTimeout(function(){
                var innerHeight = contentInner.offsetHeight;
                
                if (innerHeight > 0) {
                    contentOuter.style.height = innerHeight + 'px';
                    contentOuter.addEventListener('transitionend', resetHeight)
                } 
            }, 0);
        }

        return Boolean(tab && contentOuter && contentInner);
    }

    function closeTab(domSelector) {
        var tab = document.querySelector(domSelector)
        var contentOuter = tab && tab.querySelector('.tabContentOuter');
        
        if (contentOuter) {
            contentOuter.style.height = contentOuter.offsetHeight + 'px';
            setTimeout(function() {
                contentOuter.style.height = 0;
                contentOuter.removeEventListener('transitionend', resetHeight)
                contentOuter.addEventListener('transitionend', closeOnEnd)
            }, 0);
        }

        return Boolean(tab && contentOuter);
    }

    return {
        openTab: openTab,
        closeTab: closeTab
    };
})();