def sq(n)
  ans = 0
  0.upto(n) do |x| ans += x * x end
end
start_time = Time.now
n = 100000
sq(n)

puts "_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/"
puts start_time
puts "_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/"

# 使用するgem
require 'mechanize'
require 'nokogiri'
require 'dotenv'
require 'pry'

# ENV読み込み
Dotenv.load

# スクレイピングgem「Mechanize」初期化
agent = Mechanize.new do |a|
  a.user_agent_alias = 'Windows IE 9'
  a.verify_mode = OpenSSL::SSL::VERIFY_NONE
  a.max_history = 1
  a.open_timeout = 60
  a.read_timeout = 180
  a.conditional_requests = false
end

# スクレイピング対象サイト
page = agent.get("https://xxxxxxxxxxxxxxxxxx")
page = page.form_with(action: './index2.html') do |form|
  form.id = ENV['ID'] # ログイン情報をENVにて実装
  form.pass = ENV['PS']
end.submit

# 条件のエリア設定
def request_area(area)
  if area.include?("東京都")
    true
  elsif area.include?("神奈川県")
    true
  elsif area.include?("埼玉県")
    true
  elsif area.include?("千葉県")
    true
  elsif area.include?("茨城県")
    true
  elsif area.include?("山梨県")
    true
  elsif area.include?("静岡県")
    true
  else
    false
  end
end

# 条件の予算設定
def confirmation_budget(budget)
  if budget.include?("総額予算")
    if budget.include?("相場が分らない")
      true
    elsif budget.include?("予算上限なし")
      true
    elsif budget.include?("1万円まで")
      false
    elsif budget.include?("3万円まで")
      false
    elsif budget.include?("5万円まで")
      false
    elsif budget.include?("7万円まで")
      false
    elsif budget.include?("10万円まで")
      false
    elsif budget.include?("15万円まで")
      false
    elsif budget.include?("30万円まで")
      false
    elsif budget.include?("50万円まで")
      true
    else
      true
    end
  else
    if budget.include?("相場が分らない")
      true
    elsif budget.include?("予算上限なし")
      true
    elsif budget.include?("月5千円まで")
      false
    elsif budget.include?("月1万円まで")
      false
    elsif budget.include?("月2万円まで")
      false
    elsif budget.include?("月3万円まで")
      false
    elsif budget.include?("月5万円まで")
      true
    elsif budget.include?("月7万円まで")
      true
    elsif budget.include?("月10万円まで")
      true
    else
      true
    end
  end
end

# 既に条件不一致がわかっている案件のスルー初期変数設定
false_id = []
false_id_count = 0
through_number = 0
submit_finished = false
current_loop = 0 # 現在のループ数
number_of_loops = rand(599..999) # ループ回数の決定

#  プログラムスリープの変数設定
def_short_time = [rand(20..99), rand(100..299), rand(300..399), rand(400..599), rand(600..699), rand(700..899), rand(900..999), rand(1000..1199)]
short_time = Array.new(250){ rand 300..1299 }
long_time = [rand(100..499), rand(500..899), rand(900..1199)]
matter_number = 0
# ここまでが下準備&各種変数等の初期設定

# ここからプログラムのロジック部分開始
puts "#{Time.now} Loop start. #{number_of_loops} loops"
puts "---------------------------------------------------------"
while current_loop < number_of_loops do
  intermediate_time = Time.now
  number_throughs = 0
  number_successes = 0
  exception_handling = 0
  list_page = 'https://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
  list_page = agent.get(list_page)
  list_page.encoding = 'eucJP-MS'
  while matter_number <= 9 do
    begin
      # Webページ上の表示情報を変数へ代入
      matter_list = list_page.search('.sj_limit')[matter_number].text
      matter_type = list_page.search('.sj_flow')[matter_number].text
      matter_link = list_page.search('.sj_detail h4 a')[matter_number]
      matter_title = list_page.search('.sj_detail h4 a')[matter_number].text
      matter_area = list_page.search('.sj_info')[matter_number].text
      matter_desc = list_page.search('.sj_info2')[matter_number].text
      matter_id = list_page.search('.lump_tid')[matter_number].text
      matter_id = matter_id.gsub(/[^\d]/, "").to_i
      if matter_type.include?("ホームページ") && request_area(matter_area)
        unless matter_list.include?("参加枠なし") || matter_list.include?("終了") || matter_list.include?("メッセージ履歴") || matter_list.include?("参加希望申請中")
          unless false_id.include?(matter_id)
            # 条件に合致するものだけ2段階目の処理へ移行
            puts "#{Time.now} 2nd page scraping..."
            puts "title : #{matter_title}"
            puts "---------------------------------------------------------"
            details_page = agent.click(matter_link)
            case_details = agent.get(details_page)
            case_details.encoding = 'eucJP-MS'
            budget_limit = case_details.search('.budget_limit').text
            if confirmation_budget(budget_limit)
              last_page = case_details.form_with(action: 'toiawase_conf.html') do |form|
                form.field_with(name: 'flg').value = '0'
              end.submit
              # 条件に合致するものだけ最終処理へ移行
              puts "#{Time.now} Final page scraping..."
              last_page.encoding = 'eucJP-MS'
              finish_page = last_page.form_with(action: 'toiawase_comp.html') do |form|
                form.field_with(name: 'select_txt').value = '0'
                form.field_with(name: 'mail_text').value = "ここに案件参加時のコメントを入力します。"
              end.submit
              submit_finished = true
              number_successes += 1
              puts "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww"
              puts "#{Time.now} The bid was successful!"
              puts "title : #{matter_title}"
              puts "description : #{matter_desc}"
              puts "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww"
            else
              false_id[false_id_count] = matter_id
              false_id_count += 1 
              puts "#{Time.now} Case #{matter_number} did not meet the conditions"
              puts "title : #{matter_title}"
              puts "description : #{matter_desc}"
              puts "---------------------------------------------------------"
            end
          end
        end
      end
      matter_number += 1
      unless submit_finished
        number_throughs += 1
        submit_finished = false
      end
    # ロジック途中でエラーが発生した場合の例外処理
    rescue => e
      matter_number += 1
      exception_handling += 1
      puts "#{Time.now} error!"
      puts "title : #{matter_title}"
      puts "description : #{matter_desc}"
      puts "---------------------------------------------------------"
    end
  end

  # プログラムのスリープ条件分岐（相手サーバーへの負荷軽減）
  if short_time.include?(current_loop)
    short_stop = rand(1..10)
    puts "#{Time.now} Short stop. #{short_stop}"
    puts "---------------------------------------------------------"
    sleep short_stop
  end
  if long_time.include?(current_loop)
    long_stop = rand(150..320)
    puts "#{Time.now} Long stop. #{long_stop})"
    puts "---------------------------------------------------------"
    sleep long_stop
  end
  if def_short_time.include?(current_loop)
    def_short_stop = rand(15..35)
    puts "#{Time.now} Def short stop. #{def_short_stop}"
    puts "---------------------------------------------------------"
    sleep def_short_stop
  end
  matter_number = 0
  current_loop += 1
  end_time = Time.now
  colapsed_time = end_time - intermediate_time
  puts "#{Time.now} End #{current_loop} loops.."
  puts "---------------------------------------------------------"
end

end_time = Time.now
colapsed_time = end_time - start_time
puts "#{Time.now} All time:#{colapsed_time}sec"
puts "#{Time.now} End time #{end_time}"

# binding.pry 問題起きたとき用の調査ツール
# 実運用時はcronを使用し定時実行＆ログファイルを残す