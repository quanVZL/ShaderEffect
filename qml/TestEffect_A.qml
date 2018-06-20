import QtQuick 2.9

Rectangle {
    id: root
    width: 1024
    height: 694
    color: "black"

    Image {
        id: sourceImage
        source: "qrc:/Image/1.jpg"
    }

    ShaderEffect {
        id: rootShader
        anchors.fill: parent
        property real timer: 0.0
        property real smokeAlpha: 0.0
        // 可直接修改Image透明度替代
        property real imageVisibility: 0.0

        SequentialAnimation {
            running: true
            loops: -1
            ParallelAnimation {
                NumberAnimation { target: rootShader; property: "timer"; from: 0.0; to: 10; duration: 5000 }
                NumberAnimation { target: rootShader; property: "smokeAlpha"; from: 0.0; to: 1.0; duration: 5000 }
                NumberAnimation { target: rootShader; property: "imageVisibility"; from: 0.0; to: 1.0; duration: 5000 }
            }
            ParallelAnimation {
                NumberAnimation { target: rootShader; property: "timer"; to: 20.0; duration: 5000 }
                NumberAnimation { target: rootShader; property: "smokeAlpha"; to: 0.0; duration: 5000 }
            }
            ParallelAnimation {
                NumberAnimation { target: rootShader; property: "timer"; to: 10.0; duration: 5000 }
                NumberAnimation { target: rootShader; property: "smokeAlpha"; to: 1.0; duration: 5000 }
                NumberAnimation { target: rootShader; property: "imageVisibility"; from: 1.0; to: 0.0; duration: 5000 }
            }
            ParallelAnimation {
                NumberAnimation { target: rootShader; property: "timer"; to: 0.0; duration: 5000 }
                NumberAnimation { target: rootShader; property: "smokeAlpha"; from: 1.0; to: 0.0; duration: 5000 }
            }
        }

        fragmentShader: "
            uniform float timer;
            uniform float smokeAlpha;
            uniform float imageVisibility;

            float getPoint(vec2 n) {
                return fract(cos(dot(n, vec2(36.26, 73.12))) * 354.63);
            }

            float noise(vec2 n) {
                vec2 fn = floor(n);
                vec2 sn = smoothstep(vec2(0.0, 0.0), vec2(1.0, 1.0), fract(n));

                float h1 = mix(getPoint(fn), getPoint(fn + vec2(1.0, 0.0)), sn.x);
                float h2 = mix(getPoint(fn + vec2(0.0, 1.0)), getPoint(fn + vec2(1.0, 1.0)), sn.x);
                return mix(h1, h2, sn.y);
            }

            float value(vec2 n) {
                float total;
                total = noise(n/32.0) * 0.5875 + noise(n/16.0) * 0.2 + noise(n/8.0) * 0.1 +
                        noise(n/4.0) * 0.05 + noise(n/2.0) * 0.025 + noise(n) * 0.0125;
                return total;
            }

            void main() {
                // vec3 value * alpha 控制烟雾的透明度, vec4 第四个参数 控制底图是否可见 为1.0时底图为黑色  Image不可见
                gl_FragColor = vec4(vec3(value(timer * 16.0 + gl_FragCoord.xy / 4.0) * smokeAlpha), imageVisibility);
            }
            "
    }
}
