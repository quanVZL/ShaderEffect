import QtQuick 2.9

Item {
    id: root
    width: 1024
    height: 694

    property int index: 1

    function change() {
        var index_tmp = index
        if (index_tmp === 6) index_tmp = 0;
        index_tmp = (index_tmp + 1) % 7;

        index = index_tmp;

        console.log(index)
    }

    Image {
        id: sourceImage
        visible: false
        source: "qrc:/Image/inkPainting" + index + ".jpg"
    }

    ShaderEffect {
        id: rootShader
        anchors.centerIn: parent
        width: sourceImage.width
        height: sourceImage.height

        property real rootWidth: rootShader.width
        property real rootHeight: rootShader.height
        property variant source: sourceImage

        property real timer: 0

        SequentialAnimation {
            running: true
            loops: -1
            NumberAnimation { target: rootShader; property: "timer"; from: 0; to: 3.14 * 0.5; duration: 3000 }
            ScriptAction {
                script: {
                    change();
                }
            }
            NumberAnimation { target: rootShader; property: "timer"; from: 3.14 * 0.5; to: 0; duration: 3000 }
        }

        fragmentShader: "
            uniform float rootWidth;
            uniform float rootHeight;
            uniform sampler2D source;
            uniform float timer;
            varying vec2 qt_TexCoord0;

            float getPoint(in vec2 n) {
                return fract(cos(n.x * 42.98 + n.y * 43.23) * 1127.53);
            }

            float noise(in vec2 n) {
                vec2 fn = floor(n);
                vec2 sn = smoothstep(vec2(0.0, 0.0), vec2(1.0, 1.0), fract(n));

                float h1 = mix(getPoint(fn), getPoint(fn + vec2(1.0, 0.0)), sn.x);
                float h2 = mix(getPoint(fn + vec2(0.0, 1.0)), getPoint(fn + vec2(1.0, 1.0)), sn.x);
                return mix(h1, h2, sn.y);
            }

            float value(in vec2 n) {
                float total;
                total = noise(n/32.0) * 0.58 + noise(n/16.0) * 0.2 + noise(n/8.0) * 0.1 +
                        noise(n/4.0) * 0.05 + noise(n/2.0) * 0.025 + noise(n) * 0.0125;
                return total;
            }

            void main() {
                vec2 iResolution = vec2(rootWidth, rootHeight);
                vec2 uv = qt_TexCoord0;

                float t = abs(sin(timer));

                gl_FragColor = mix(texture2D(source, uv), vec4(0), smoothstep(t + 0.1, t - 0.1, value(gl_FragCoord.xy * 0.4)));
            }
"
    }
}
