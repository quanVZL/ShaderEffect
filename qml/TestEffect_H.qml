import QtQuick 2.9

Item {
    id: root
    width: 1024
    height: 694

    ShaderEffect {
        id: rootShader
        anchors.fill: parent

        property real iTimer: 0.0
        property real targetWidth: rootShader.width
        property real targetHeight: rootShader.height
        property real distance: distance.value

        SequentialAnimation {
            running: true
            loops: -1
            NumberAnimation { target: rootShader; property: "iTimer"; from: 0.0; to: 3.1415926 * 2; duration: 5000 }
            NumberAnimation { target: rootShader; property: "iTimer"; from: 3.1415926 * 2; to: 0.0; duration: 5000 }
        }

        fragmentShader: "
            uniform float iTimer;
            uniform float targetWidth;
            uniform float targetHeight;
            uniform float distance;
            varying vec2 qt_TexCoord0;

            vec3 calc(float r, vec2 uv) {
                vec3 col;
                float c;
                // 动的不是这个球， 是你得眼睛, 改变lightX、lightY实现不同方向旋转
                float lightX = sin(iTimer);
                float lightY = cos(iTimer);

                vec3 light = normalize(vec3(lightX, lightY, 0.7 + distance));
                float h;
                if (r < 0.2) {
                    h = sqrt(0.04 - pow(r, 2.0));
                } else {
                    h = 0.0;
                }

                vec3 n = normalize(vec3(uv.x, uv.y, h));
                c = dot(n, light);
                c = clamp(c, 0.05, 1.0);
                col = vec3(c);
                return col;
            }

            void main() {
                vec2 iResolution = vec2(targetWidth, targetHeight);
                vec2 uv = gl_FragCoord.xy / iResolution.xy;
                uv -= vec2(0.5, 0.5);
                uv.x *= iResolution.x /iResolution.y;

                vec3 col;
                float r = length(uv);
                float c;

                if (r < 0.2) {
                    col = calc(r, uv);
                } else {
                    vec3 on = calc(r, uv);
                    vec3 off = vec3(0.0, 0.0, 0.0);
                    float mixFactor = smoothstep(0.2, 0.21, r); //光线可视
                    col = mix(on, off, mixFactor);
                }

                gl_FragColor = vec4(col, 1.0);
            }"
    }

    CommonSlider {
        id: distance
        anchors.left: parent.left
        anchors.leftMargin: 10
        mix: -5
        max: 5
        key: "distance"
    }
}



















