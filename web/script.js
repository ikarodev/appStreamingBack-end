
async function jsOpenTab(url, target) {
    let promise = new Promise(function (resolve, reject) {
        var win = window.open(url, target);
        console.log("window", win);
        // var timer = setInterval(function () {
        //     if (win.closed) {
        //         clearInterval(timer);
        //         alert("'Popup Window' closed!");
        //         resolve('Paid');
        //     }
        // }, 500);
        console.log("window", win);
    });
    let result = await promise;
    console.log("result", result);
    return result;
}

// Funções para controlar o reCAPTCHA
function showRecaptcha() {
    const container = document.getElementById('recaptcha-container');
    if (container) {
        container.style.display = 'block';
        console.log('reCAPTCHA container mostrado');
    }
}

function hideRecaptcha() {
    const container = document.getElementById('recaptcha-container');
    if (container) {
        container.style.display = 'none';
        console.log('reCAPTCHA container ocultado');
    }
}

// Função para verificar se o reCAPTCHA está disponível
function isRecaptchaReady() {
    return typeof grecaptcha !== 'undefined' && grecaptcha.render;
}