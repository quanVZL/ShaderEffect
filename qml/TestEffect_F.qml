import QtQuick 2.9

Item {
    id: root
    width: 1024
    height: 694

    Image {
        id: sourceImage
        visible: false
        source: "qrc:/Image/water1.jpg"
    }

    ShaderEffect {
        id: rootShader
        width: sourceImage.width
        height: sourceImage.height
        anchors.centerIn: parent

        property variant source: sourceImage
        property real iTime: 0.0

        property real targetWidth: rootShader.width
        property real targetHeight: rootShader.height

        property real value: d.value
        property real gradient: intensity.value
        property real rainValue: rainFall.value

        Timer {
            running: true
            interval: 16
            repeat: true
            onTriggered: {
                rootShader.iTime += 3.1415926 * 2 / 600;
            }
        }

//        SequentialAnimation {
//            running: true
//            loops: -1
//            NumberAnimation { target: rootShader; property: "iTime"; from: 0.0; to: 3.1415926 * 2; duration: 10000 }
//            NumberAnimation { target: rootShader; property: "iTime"; from: 3.1415926 * 2; to: 0.0; duration: 10000 }
//        }

        fragmentShader: "
            uniform float iTime;
            uniform sampler2D source;
            varying vec2 qt_TexCoord0;
            uniform float targetHeight;
            uniform float targetWidth;

            uniform float value;
            uniform float gradient;
            uniform float rainValue;


            #define MAX_RADIUS      2
            #define DOUBLE_HASH     0
            #define HASHSCALE1      0.1031
            #define HASHSCALE3      vec3(0.1031, 0.1030, 0.0973)

            float hash(vec2 p) {
                vec3 n = fract(vec3(p.xyx) * HASHSCALE1);
                n += dot(n, n.yzx + 19.19);
                return fract((n.x + n.y) * n.z);
            }

            vec2 hash22(vec2 p) {
                vec3 n = fract(vec3(p.xyx) * HASHSCALE3);
                n += dot(n, n.yzx + 19.19);
                return fract((n.xx + n.yz) * n.zy);
            }

            void main() {

                float resolution = 10.0 * value * exp2(-3.0*0.0);
                vec2 iResolution = vec2(targetWidth, targetHeight);
                vec2 uv = gl_FragCoord.xy / targetHeight * resolution;
                vec2 p0 = floor(uv);

                vec2 circles = vec2(0.0);

                for (int j = -MAX_RADIUS; j <= MAX_RADIUS; ++j) {
                    for (int i = -MAX_RADIUS; i <= MAX_RADIUS; ++i) {
                        vec2 pi = p0 + vec2(i, j);

//                        #if DOUBLE_HASH
                        vec2 hsh = hash22(pi);          // hash22(pi * 0.0)
//                        #else
//                        vec2 hsh = pi;
//                        #endif

                        vec2 p = pi + hash22(hsh);

                        float t = fract(0.3 * iTime + hash(hsh));
                        vec2 v = p - uv;
                        float d = length(v) - (float(MAX_RADIUS) + 1.0) * t;
                        // 此处不是 1e - 3
                        float h = 1e-3;
                        float d1 = d - h;
                        float d2 = d + h;
                        float p1 = rainValue * sin(31.0 * d1) * smoothstep(-0.6, -0.3, d1) * smoothstep(0.0, -0.3, d1);
                        float p2 = rainValue * sin(31.0 * d2) * smoothstep(-0.6, -0.3, d2) * smoothstep(0.0, -0.3, d2);

                        circles += 0.5 * normalize(v) * ((p2 - p1) / (2.0 * h) * (1.0 - t) * (1.0 - t));
                    }
                }
                // float 中数字为整数
                circles /= float((MAX_RADIUS*2 + 1)*(MAX_RADIUS*2 + 1));
                float intensity = mix(0.01, 0.15, smoothstep(0.1, 0.6, abs(fract(0.05 * gradient * iTime + 0.5) * 2.0 - 1.0)));
                vec3 n = vec3(circles, sqrt(1.0 - dot(circles, circles)));
                vec3 color = texture2D(source, qt_TexCoord0 - intensity * n.xy).rgb + 5.0 * pow(clamp(dot(n, normalize(vec3(1.0, 0.7, 0.5))), 0.0, 1.0), 6.0);
                gl_FragColor = vec4(color, 1.0);
            }
"
    }

    CommonSlider {
        id: d
        anchors.left: parent.left
        anchors.leftMargin: 10
        mix: 0.01
        key: "scale"
    }

    CommonSlider {
        id: intensity
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: d.bottom
        anchors.topMargin: 10
        key: "intensity"
        mix: 0.0
        max: 1.0
    }
    CommonSlider {
        id: rainFall
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: intensity.bottom
        anchors.topMargin: 10
        key: "rainFall"
        mix: 0.0
        max: 1.0
    }
}


