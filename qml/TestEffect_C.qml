import QtQuick 2.9

Item {
    id: root
    width: 1024
    height: 694

    Image {
        id: sourceImage1
        visible: false
        source: "qrc:/Image/person1.jpg"
    }

    Image {
        id: sourceImage2
        visible: false
        source: "qrc:/Image/person2.jpg"
    }

    ShaderEffect {
        id: rootShader
        width: source1.width
        height: source1.height
        anchors.centerIn: parent
        property real targetWidth: rootShader.width
        property real targetHeight: rootShader.height
        property real iTime: 3.1415926 * 0.5

        property variant source1: sourceImage1
        property variant source2: sourceImage2

        SequentialAnimation {
            running: true
            loops: -1
            NumberAnimation { target: rootShader; property: "iTime"; from: 3.1415926 * 0.5; to: 3.1415926 * 1.5; duration: 5000; easing.type: Easing.InOutQuad }
            NumberAnimation { target: rootShader; property: "iTime"; from: 3.1415926 * 1.5; to: 3.1415926 * 0.5; duration: 5000; easing.type: Easing.InOutQuad }
        }

        fragmentShader: "
            uniform float targetWidth;
            uniform float targetHeight;
            uniform float iTime;
            uniform sampler2D source1;
            uniform sampler2D source2;
            varying vec2 qt_TexCoord0;

            vec2 mod(vec2 x) {
                return x - floor(x * (1.0/289.0)) * 289.0;
            }

            vec3 mod(vec3 x) {
                return x - floor(x * (1.0/289.0)) * 289.0;
            }

            vec3 permute(vec3 x) {
                return mod(((x * 34.0) + 1.0) * x);
            }

            float noise(vec2 v) {
                const vec4 mark_tmp = vec4(0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439);

                vec2 firstCorner = floor(v + dot(v, mark_tmp.yy));
                vec2 x0 = v - firstCorner + dot(firstCorner, mark_tmp.xx);

                vec2 secondCorner;
                secondCorner = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
                vec4 x12 = x0.xyxy + mark_tmp.xxzz;
                x12.xy -= secondCorner;

                firstCorner = mod(firstCorner);

                vec3 p = permute(permute(firstCorner.y + vec3(0.0, secondCorner.y, 1.0)) + firstCorner.x + vec3(0.0, secondCorner.x, 1.0));
                vec3 m = max(0.5 - vec3(dot(x0, x0), dot(x12.xy, x12.xy), dot(x12.zw, x12.zw)), 0.0);
                m = m * m * m * m;

                vec3 x = 1.0 * fract(p * mark_tmp.www) - 1.0;
                vec3 h = abs(x) - 0.5;
                vec3 ox = floor(x + 0.5);
                vec3 a0 = x - ox;

                m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

                vec3 g;
                g.x  = a0.x  * x0.x  + h.x  * x0.y;
                g.yz = a0.yz * x12.xz + h.yz * x12.yw;
                return 130.0 * dot(m, g);
            }

            void main() {
                vec2 uv = qt_TexCoord0;

                vec2 pos =  uv;

                pos.x =  noise(vec2(pos.x * 2.0));

                float noise_tmp = noise(pos);

                vec4 texture1 = texture2D(source1, uv);
                vec4 texture2 = texture2D(source2, uv);

                float step = sin(iTime);

                gl_FragColor = texture1 * smoothstep(step, step, noise_tmp) +
                               texture2 * (1.0 - smoothstep(step, step, noise_tmp));
            }
"
    }

    Text {
        anchors.centerIn: parent
        text: rootShader.iTime.toFixed(3)
        color: "red"
        font.pixelSize: 32
    }
}
