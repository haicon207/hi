import requests
import json

# =====================================
# STREAM PAGE — LOAD TỪNG PAGE NGAY
# =====================================
def stream_pages():
    url = "https://www.facebook.com/api/graphql/"

    next_cursor = None

    while True:
        # VARIABLES giống format em yêu cầu
        if next_cursor:
            variables = (
                "{\"id\":\"61561014102021\","
                "\"scale\":3,"
                "\"__relay_internal__pv__StoriesRingrelayprovider\":false,"
                "\"cursor\":\"" + next_cursor + "\"}"
            )
        else:
            variables = (
                "{\"id\":\"61561014102021\","
                "\"scale\":3,"
                "\"__relay_internal__pv__StoriesRingrelayprovider\":false}"
            )

        payload = {
            'av': "61561014102021",
            '__user': "61561014102021",
            'fb_dtsg': "NAfsRaNbworjjRKW8lLYDLlbtYzvND9j_AzDtEvAsRC_sXjk5UoxNrQ:10:1764783603",
            '__crn': "comet.fbweb.PageCometLaunchpointInvitesRoute",
            'fb_api_caller_class': "RelayModern",
            'fb_api_req_friendly_name': "PagesCometPagesLikedRootQuery",
            'server_timestamps': "true",
            'variables': variables,      # dùng chuỗi nối y hệt em đưa
            'doc_id': "24957115270544885"
        }

        headers = {
            'User-Agent': "Mozilla/5.0",
            'x-fb-lsd': "KnYpK1An2rIyQMlLs3fMwK",
            'x-asbd-id': "359341",
            'origin': "https://www.facebook.com",
            'referer': "https://www.facebook.com/pages/?category=invites&ref=bookmarks",
            'Cookie': "presence=C%7B%22t3%22%3A%5B%5D%2C%22utc3%22%3A1764783727998%2C%22v%22%3A1%7D; wd=900x1574; dpr=3; fr=0xF3kxmKQdR3dwgIf.AWfJ2y71mOoldzjgSknonwLFXzelVDvJr5T2eVD07IHSxjjI7XU.BpMHWs..AAA.0.0.BpMHYB.AWfZDwMmLqCRWFx2kZ1rDR7qnd4; fbl_st=100632753%3BT%3A29413060; ps_l=1; ps_n=1; vpd=v1%3B724x414x3; c_user=61561014102021; locale=vi_VN; pas=61561014102021%3AxSTdmhmcjs; sb=rHUwafu29dU7oZdtlloVRKXd; wl_cbv=v2%3Bclient_version%3A3005%3Btimestamp%3A1764783606; xs=10%3AqYFvEYugRbRXRQ%3A2%3A1764783603%3A-1%3A-1; m_pixel_ratio=3; datr=rHUwaXJqJPxYXBk9yeAERsC0"
        }

        res = requests.post(url, data=payload, headers=headers)

        try:
            data = res.json()
        except:
            print("JSON lỗi")
            continue

        try:
            root = data["data"]["user"]["sorted_liked_and_followed_pages"]
            edges = root["edges"]
        except KeyError:
            print("Không tìm thấy pages")
            break

        # Yield từng page
        for item in edges:
            node = item["node"]
            yield {"id": node.get("id"), "name": node.get("name")}

        # NEXT CURSOR
        page_info = root.get("page_info", {})
        next_cursor = page_info.get("end_cursor")
        has_next = page_info.get("has_next_page", False)

        if not has_next:
            break


# =====================================
# UNFOLLOW PAGE
# =====================================
def unfollow_page(page_id):
    url = "https://www.facebook.com/api/graphql/"

    variables = (
        "{\"input\":{"
        "\"subscribe_location\":\"PAGE_FAN\","
        "\"unsubscribee_id\":\"" + str(page_id) + "\","
        "\"actor_id\":\"61561014102021\","
        "\"client_mutation_id\":\"2\"}}"
    )

    payload = {
        'av': "61561014102021",
        '__user': "61561014102021",
        'fb_dtsg': "NAfsRaNbworjjRKW8lLYDLlbtYzvND9j_AzDtEvAsRC_sXjk5UoxNrQ:10:1764783603",
        '__crn': "comet.fbweb.PageCometLaunchpointLikedPagesListRoute",
        'fb_api_caller_class': "RelayModern",
        'fb_api_req_friendly_name': "usePageCometUnfollowMutation",
        'server_timestamps': "true",
        'variables': variables,   # giữ nguyên định dạng string
        'doc_id': "23977842521823837"
    }

    headers = {
        'User-Agent': "Mozilla/5.0",
        'x-fb-lsd': "KnYpK1An2rIyQMlLs3fMwK",
        'x-asbd-id': "359341",
        'origin': "https://www.facebook.com",
        'referer': "https://www.facebook.com/pages/?category=liked&ref=bookmarks",
        'Cookie': "presence=C%7B%22t3%22%3A%5B%5D%2C%22utc3%22%3A1764783727998%2C%22v%22%3A1%7D; wd=900x1574; dpr=3; fr=0xF3kxmKQdR3dwgIf.AWfJ2y71mOoldzjgSknonwLFXzelVDvJr5T2eVD07IHSxjjI7XU.BpMHWs..AAA.0.0.BpMHYB.AWfZDwMmLqCRWFx2kZ1rDR7qnd4; fbl_st=100632753%3BT%3A29413060; ps_l=1; ps_n=1; vpd=v1%3B724x414x3; c_user=61561014102021; locale=vi_VN; pas=61561014102021%3AxSTdmhmcjs; sb=rHUwafu29dU7oZdtlloVRKXd; wl_cbv=v2%3Bclient_version%3A3005%3Btimestamp%3A1764783606; xs=10%3AqYFvEYugRbRXRQ%3A2%3A1764783603%3A-1%3A-1; m_pixel_ratio=3; datr=rHUwaXJqJPxYXBk9yeAERsC0"
    }

    r = requests.post(url, data=payload, headers=headers)

    try:
        d = r.json()
        status = d["data"]["actor_unsubscribe"]["unsubscribee"]["subscribe_status"]
        return status == "CAN_SUBSCRIBE"
    except:
        return False


# =====================================
# MAIN — LOAD TỚI ĐÂU HỦY TỚI ĐÓ
# =====================================
for p in stream_pages():
    ok = unfollow_page(p["id"])

    if ok:
        print("THÀNH CÔNG |ID|", p["id"], "|NAME|", p["name"])
    else:
        print("THẤT BẠI |ID|", p["id"], "|NAME|", p["name"])

    print("------------")