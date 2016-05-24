//
//  server_address.h
//  IAM_IOS_ObjectiveC
//
//  Created by KMK on 2016. 4. 9..
//  Copyright © 2016년 KMK. All rights reserved.
//

#ifndef server_address_h
#define server_address_h

#define sign_up @"http://52.69.46.152:8000/api/sign_up"   //카카오톡 가입
#define download_card @"http://52.69.46.152:8000/api/download_card" // 카드 자세히보기

//카드 삭제
#define delete_card  @"http://52.69.46.152:8000/api/delete_card"

//사진 삭제
#define delete_picture @"http://52.69.46.152:8000/api/delete_picture"
 //사진 변경
#define modify_picture @"http://52.69.46.152:8000/api/modify_picture"
//사진 추가
#define insert_picture @"http://52.69.46.152:8000/api/insert_picture"

//카드 json변경
#define card_json_modify @"http://52.69.46.152:8000/api/modify_json"
 //카드 메인 이미지변경
#define modify_profile @"http://52.69.46.152:8000/api/modify_profile"

#define random_info @"http://52.69.46.152:8000/api/find_members/random"
#define interest_info @"http://52.69.46.152:8000/api/find_members/interest"

#define card_image_upload @"http://52.69.46.152:8000/api/upload_card"
#define POST_BODY_BOURDARY "------WebKitFormBoundaryQGvWeNAiOE4g2VM5--" 

#endif /* server_address_h */
