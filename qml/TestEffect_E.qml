import QtQuick 2.9

Item {
    id: root
    width: 1024
    height: 694

    Image {
        id: sourceImage1
        visible: false
        source: "qrc:/Image/1.jpg"
    }

    Image {
        id: sourceImage2
        visible: false
        source: "qrc:/Image/1_gray.jpg"
    }

    ShaderEffect {
        id: rootShader
        width: sourceImage1.width
        height: sourceImage1.height

        property real iTime: 0.0
        property variant source1: sourceImage1
        property variant source2: sourceImage2

        SequentialAnimation {
            running: true
            loops: -1
            NumberAnimation { target: rootShader; property: "iTime"; from: 0.0; to: 3.1415926 * 2; duration: 3000 }
            NumberAnimation { target: rootShader; property: "iTime"; from: 3.1415926 * 2; to: 0.0; duration: 3000 }
        }

        fragmentShader: "
            uniform sampler2D source1;
            uniform sampler2D source2;
            uniform float iTime;
            varying vec2 qt_TexCoord0;

            float getPoint(vec2 p) {
                return fract(cos(p.x * 42.98 + p.y * 43.23) * 1127.53);
            }

            float noise(vec2 p) {
                vec2 fn = floor(p);
                vec2 sn = smoothstep(vec2(0.0, 0.0), vec2(1.0, 1.0), fract(p));

                float h1 = mix(getPoint(fn), getPoint(fn + vec2(1.0, 0.0)), sn.x);
                float h2 = mix(getPoint(fn + vec2(0.0, 1.0)), getPoint(fn + vec2(1.0,1.0)), sn.x);

                return mix(h1, h2, sn.y);
            }

            float value(vec2 n) {
                float total;
                total = noise(n/32.0) * 0.58 + noise(n/16.0) * 0.2 + noise(n/8.0) * 0.1 +
                        noise(n/4.0) * 0.05 + noise(n/2.0) * 0.025 + noise(n) * 0.0125;
                return total;
            }

            vec3 background(vec2 pos) {
                vec3 color = vec3(1.0);

                for (int i = 0; i < 3; ++i) {
                    color += mix(texture2D(source2, pos),
                                 texture2D(source2, pos),
                                 abs(mod(float(i) * 0.666, 2.0) - 1.0) ).xyz;
                }
                return color * vec3(0.25, 0.25, 0.25);
            }

            void main() {
                vec2 uv = qt_TexCoord0;
                float t = mod(iTime * 0.15, 1.2);

                gl_FragColor = mix(texture2D(source1, uv), vec4(0.0), smoothstep(t + 0.1, t - 0.1, value(gl_FragCoord.xy * 0.4)));

                gl_FragColor.rgb = clamp(gl_FragColor.rgb + step(gl_FragColor.a, 0.1) * 1.6 * value(2000.0 * uv) * vec3(1.2, 0.5, 0.0), 0.0, 1.0);

                gl_FragColor.rgb = gl_FragColor.rgb * step(0.021, gl_FragColor.a) +  background(1.0 * uv) * step(gl_FragColor.a, 0.021);
            }"
    }
}
