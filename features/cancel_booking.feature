# Feature: Cancel booking
#     Odds อยากจะยกเลิกการจองห้องประชุมเมื่อไม่ต้องการใช้แล้วเพื่อให้คนอื่นสามารถจองได้

#     Scenario: กดยกเลิกการจองห้องประชุมสำเร็จ
#         Given ฉันเข้าสู่ระบบแล้ว
#         And ฉันทำการจองแล้ว
#         When ฉันกดดูรายการจองของฉัน
#         And ฉันกดยกเลิกการจอง
#         Then ฉันจะไม่เห็นรายการจองที่ได้ทำการยกเลิกไปแล้ว