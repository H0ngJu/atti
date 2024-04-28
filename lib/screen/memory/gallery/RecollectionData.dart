class RecollectionData {
  final String img;
  final String title;
  final int year;
  final String description;

  RecollectionData({
    required this.img,
    required this.title,
    required this.year,
    required this.description,
  });
}

// Step 2: 더미 데이터 생성
final List<RecollectionData> dummyData = [
  RecollectionData(
    img: 'https://blog.kakaocdn.net/dn/2h10F/btq8dRCx1EV/jqApAsqIaPar9KIiLhfV8K/img.jpg',
    title: '현미',
    year: 1960,
    description: '\"현미의 밤안개\"는 대중가요 사상 가장 유명한 대표곡 중 하나로, 1960년대에 큰 사랑을 받았던 곡입니다. 이 노래는 가수 현미가 불렀으며, 그녀의 특유의 애절한 목소리와 감성적인 멜로디로 많은 사람들의 가슴을 울렸습니다. '
        '\"밤안개\"는 이별과 그리움을 주제로 한 가사로, 당시 많은 사람들이 겪고 있었던 사회적, 개인적 아픔과 그리움을 대변하는 곡으로 평가받습니다.'
  ),
  RecollectionData(
      img: 'https://www.imaeil.com/photos/2018/08/26/2018082611535866551_l.jpg',
      title: '여로',
      year: 1970,
      description: '1970년대 한국의 드라마 \"여로\"는 한국 방송사상 중요한 작품 중 하나로, 한국 전쟁 이후의 혼란스러운 사회 상황 속에서 살아가는 사람들의 삶과 사랑, 그리고 희망에 대한 이야기를 담고 있습니다. 당시의 사회적, 정치적 상황을 반영하며, 인간의 본성과 갈등, 가족 간의 사랑과 우정 등 다양한 주제를 다루었습니다. '
          '\"여로\"는 그 당시 대중문화에서 드문 형식의 드라마였으며, 한국 드라마의 발전에 있어 중요한 이정표를 세운 작품으로 평가받고 있습니다. 특히, 당시 사회적으로 금기시되었던 여러 주제들을 다루면서 시청자들에게 큰 반향을 일으켰고, 많은 사람들에게 깊은 인상을 남겼습니다.'
  ),
];