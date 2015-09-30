require 'RMagick'
include Magick
'''
算数型验证码
支持简单的两项式
'''
class VerifyCode
  def self.createEquation(operator, op1_range, op2_range)
    op = operator[rand(operator.length)]
    e2 = rand(op2_range)
    if op == '÷'
      max_times = op1_range.max / e2
      min_times = (op1_range.min / e2.to_f).ceil
      e1 = e2 * rand(min_times..max_times)
    else
      e1 = rand(op1_range)
    end
    case op
    when '+'
      result = e1 + e2
    when '-'
      result = e1 - e2
    when '×'
      result = e1 * e2
    when '÷'
      result = e1 / e2
    end
    return "#{e1}#{op}#{e2}", result
  end

  def self.build(args={})
    default_option = {
      operators: '+-×÷',
      lines: true,
      font_size: 22,
      bgcolor: ["#FFF4F4","#FCFAE1","#E9FCE1","#E1FCF8","#E1E2FC"]
    }
    option = default_option.merge(args)

    equation, result = self.createEquation(option[:operators], 10..99, 3..9)

    # 图片的宽度(px)
    option[:length] ||= (equation.length+1) * option[:font_size] * 1.2
    # 图片的高度(px)
    option[:height] ||= option[:font_size] * 2

    image = Image.new(option[:length], option[:height]){ self.background_color = option[:bgcolor][rand(option[:bgcolor].length)]}
    drawer = Magick::Draw.new

    ttf = "lib/fonts/#{rand(4)}.otf"

    lmargin = 0
    equation.length.times do |x|
        lmargin += rand(option[:font_size]*0.4)+option[:font_size]
        tmargin = option[:font_size]/2+option[:height]/2+rand(10)-6
        font_color = "rgba(#{rand(120)},#{rand(120)},#{rand(120)},#{(rand(6)+4).to_f/10})"
        drawer.annotate(image, 0, 0, lmargin, tmargin, equation[x]) do
            self.font = ttf
            self.pointsize = option[:font_size]
            self.fill = font_color
            self.affine = AffineMatrix.new(1,rand(),0,1.9,0,0)
        end
    end


    # 添加干扰线
    4.times do |x|
      drawer.stroke("rgb(#{rand(120)},#{rand(120)},#{rand(120)}")
      center_x = option[:length]/2
      x1 = rand(center_x)
      y1 = rand(option[:height])
      x2 = rand(center_x..option[:length])
      y2 = rand(option[:height])
      drawer.line(x1, y1, x2, y2)
      drawer.draw(image)
    end
    image.format = "PNG"
    {code: result.to_s, blob: image.to_blob}

  end

end
