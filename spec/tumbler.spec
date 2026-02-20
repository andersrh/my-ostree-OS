Name:           tumbler
Version:        4.20.0
Release:        1%{?dist}
Summary:        Thumbnail service for Xfce

License:        GPLv2+ and LGPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/xfce/tumbler/4.20/tumbler-%{version}.tar.bz2

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  glib2-devel
BuildRequires:  libxfce4util-devel >= 4.20.0
BuildRequires:  gdk-pixbuf2-devel
BuildRequires:  freetype-devel
BuildRequires:  libpng-devel
BuildRequires:  xfce4-dev-tools
BuildRequires:  gettext
BuildRequires:  intltool

%description
Tumbler is a D-Bus service for applications to request thumbnails for
various URI schemes and MIME types.

%package        devel
Summary:        Development files for %{name}
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description    devel
Development files for %{name}.

%prep
%autosetup

%build
%configure --disable-static
%make_build

%install
%make_install
find %{buildroot} -name '*.la' -delete

%find_lang tumbler

%files -f tumbler.lang
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_libdir}/libtumbler-1.so.*
%{_libdir}/tumbler-1/
%{_datadir}/dbus-1/services/org.xfce.Tumbler.Cache1.service
%{_datadir}/dbus-1/services/org.xfce.Tumbler.Manager1.service
%{_datadir}/dbus-1/services/org.xfce.Tumbler.Thumbnailer1.service

%files devel
%{_includedir}/tumbler-1/
%{_libdir}/libtumbler-1.so
%{_libdir}/pkgconfig/tumbler-1.pc

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 4.20.0-1
- Initial release for Xfce 4.20
