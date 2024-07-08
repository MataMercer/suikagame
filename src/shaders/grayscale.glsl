varying vec4 vpos;

#ifdef PIXEL
vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
  // texture_coords += vec2(cos(vpos.x), sin(vpos.y));
  // vec4 texcolor = Texel(tex, texture_coords);
  // return texcolor * color;
  vec4 col = texture2D(tex, texture_coords);
  float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));
  vec3 grayscale = vec3(gray);
  return vec4(grayscale, col.a);
}
#endif