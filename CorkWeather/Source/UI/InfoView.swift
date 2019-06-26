//
//  InfoView.swift
//  CorkWeather
//
//  Created by Eddie Long on 13/06/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import SwiftUI
import Proteus_UI
import Proteus_Core

struct InfoView : View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Spacer()
                Text(Strings.get("Info_Developer")).modifier(InfoLabelModifier())
                Spacer()
            }.padding(EdgeInsets.init(top: 20, leading: 0, bottom: 0, trailing: 0))
            HStack {
                Spacer()
                Text(Strings.get("Follow_Twitter")) + Text("Twitter").color(Color.blue).underline(true, color: Color.blue)
                Spacer()
            }.modifier(InfoLabelModifier()).tapAction {
                UIApplication.shared.open(URL(string:sharedConfig.twitterBio)!, options: [:], completionHandler: nil)
            }
            Spacer()
            HStack {
                Spacer()
                Image(uiImage: R.image.cork_flag()!)
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                Text(Strings.get("Info_Source")).modifier(InfoLabelModifier())
                Spacer()
            }
            
        }.background(Color("info_background"))
    }
}

#if DEBUG
struct InfoViewPreviews : PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
#endif
